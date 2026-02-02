import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/features/auth/document_scan/domain/parser/dni_parser.dart';
import 'package:partners/features/auth/document_scan/domain/parser/ce_parser.dart';
import 'package:partners/features/auth/document_scan/domain/parser/document_parser.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/ocr_usecase.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/watch_document_realt_time_usecase.dart';

part 'document_scan_state.dart';

class DocumentScanCubit extends Cubit<DocumentScanState> {
  final OcrUsecase _ocrUsecase;
  final WatchDocumentRealtTimeUsecase _watchDocumentRealtTimeUsecase;
  final List<DocumentParser> _parsers = [DniParser(), CeParser()];

  StreamSubscription<Either<AppException, String>>? _realtimeSubscription;

  DocumentScanCubit({
    required OcrUsecase ocrUsecase,
    required WatchDocumentRealtTimeUsecase watchDocumentRealtTimeUsecase,
  }) : _ocrUsecase = ocrUsecase,
       _watchDocumentRealtTimeUsecase = watchDocumentRealtTimeUsecase,
       super(const DocumentScanState());

  void startRealtimeMonitoring(CameraController cameraController) {
    if (state.status == DocumentScanStatus.processing) return;

    if (isClosed) {
      print('⚠️ Cubit cerrado, no se puede iniciar monitoreo');
      return;
    }

    stopRealtimeMonitoring();

    if (!isClosed) {
      emit(state.copyWith(status: DocumentScanStatus.cameraReady));
    }

    print('🎬 Iniciando monitoreo en tiempo real...');
    _realtimeSubscription =
        _watchDocumentRealtTimeUsecase(
          cameraController: cameraController,
        ).listen(
          (result) {
            if (isClosed) {
              print('⚠️ Cubit cerrado, ignorando datos del stream');
              return;
            }

            print('📥 Datos recibidos en el cubit');
            result.fold(
              (failure) {
                print('⚠️ [Realtime] Error leve: ${failure.message}');
              },
              (detectedText) {
                final textUpperCase = detectedText.toUpperCase();

                debugPrint(
                  '✅ Texto recibido en cubit (${textUpperCase.length} caracteres): ${textUpperCase.isEmpty ? "(vacío)" : textUpperCase.substring(0, textUpperCase.length > 100 ? 100 : textUpperCase.length)}...',
                );
                debugPrint('📋 TEXTO COMPLETO DETECTADO:\n$textUpperCase\n');

                DocumentScanResult? parsedResult;
                for (final parser in _parsers) {
                  parsedResult = parser.parse(textUpperCase);
                  if (parsedResult != null) {
                    debugPrint(
                      '✅ Documento parseado: ${parsedResult.document.type}',
                    );
                    break;
                  }
                }

                if (parsedResult != null) {
                  final isComplete = _isDocumentComplete(parsedResult);
                  debugPrint('📊 Documento completo: $isComplete');

                  if (isComplete) {
                    debugPrint('🎉 ¡Documento completo! Deteniendo escaneo...');

                    stopRealtimeMonitoring();

                    if (!isClosed) {
                      emit(
                        state.copyWith(
                          status: DocumentScanStatus.captured,
                          ocrResult: parsedResult,
                          realtimeText: null,
                        ),
                      );
                      debugPrint('✅ Estado actualizado con documento completo');
                    }
                    return;
                  }
                }

                if (!isClosed) {
                  emit(
                    state.copyWith(
                      status: DocumentScanStatus.cameraReady,
                      realtimeText: textUpperCase,
                    ),
                  );
                  debugPrint('🔄 Estado actualizado con texto');
                }
              },
            );
          },
          onError: (error) {
            print('❌ Error en stream: $error');
          },
          onDone: () {
            print('🏁 Stream completado');
          },
        );
  }

  void stopRealtimeMonitoring() {
    _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
  }

  Future<void> captureAndProcessImage(String imagePath) async {
    if (state.status == DocumentScanStatus.processing) return;
    if (isClosed) {
      print('⚠️ Cubit cerrado, no se puede procesar imagen');
      return;
    }

    stopRealtimeMonitoring();

    if (!isClosed) {
      emit(
        state.copyWith(
          status: DocumentScanStatus.processing,
          errorMessage: null,
          imagePath: imagePath,
        ),
      );
    }

    final result = await _ocrUsecase(imagePath: imagePath);

    if (isClosed) {
      return;
    }

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: DocumentScanStatus.failure,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (scanResult) {
        print('📄 ========== DATOS COMPLETOS CAPTURADOS ==========');
        print('📄 Nombre: ${scanResult.extractedName ?? "N/A"}');
        print('📄 Apellido: ${scanResult.extractedLastName ?? "N/A"}');
        print(
          '📄 Fecha de Nacimiento: ${scanResult.extractedBirthDate ?? "N/A"}',
        );
        print('📄 Género: ${scanResult.extractedGender ?? "N/A"}');
        print('📄 Tipo de Documento: ${scanResult.document.type}');
        print('📄 Número de Documento: ${scanResult.document.number}');

        if (scanResult.document is Dni) {
          print(
            '📄 Código de Seguridad: ${(scanResult.document as Dni).securityCode}',
          );
        }
        print('📄 Confianza: ${scanResult.confidence}');
        print('📄 Texto Crudo (${scanResult.rawText.length} caracteres):');
        print('📄 ${scanResult.rawText.toUpperCase()}');
        print('📄 ================================================');

        if (!isClosed) {
          emit(
            state.copyWith(
              status: DocumentScanStatus.captured,
              ocrResult: scanResult,
              realtimeText: null,
            ),
          );
        }
      },
    );
  }

  void reset() {
    stopRealtimeMonitoring();
    emit(const DocumentScanState());
  }

  void retry() {
    emit(
      state.copyWith(
        status: DocumentScanStatus.cameraReady,
        errorMessage: null,
        ocrResult: null,
        realtimeText: null,
      ),
    );
  }

  bool _isDocumentComplete(DocumentScanResult result) {
    if (result.document.number.isEmpty) return false;

    final hasName =
        result.extractedName != null && result.extractedName!.isNotEmpty;
    final hasLastName =
        result.extractedLastName != null &&
        result.extractedLastName!.isNotEmpty;
    final hasBirthDate =
        result.extractedBirthDate != null &&
        result.extractedBirthDate!.isNotEmpty;
    final hasGender =
        result.extractedGender != null && result.extractedGender!.isNotEmpty;

    debugPrint('📋 Verificación de completitud:');
    debugPrint('  - Nombre: $hasName (${result.extractedName ?? "N/A"})');
    debugPrint(
      '  - Apellido: $hasLastName (${result.extractedLastName ?? "N/A"})',
    );
    debugPrint(
      '  - Fecha Nacimiento: $hasBirthDate (${result.extractedBirthDate ?? "N/A"})',
    );
    debugPrint('  - Género: $hasGender (${result.extractedGender ?? "N/A"})');

    return hasName && hasLastName && hasBirthDate && hasGender;
  }

  @override
  Future<void> close() {
    stopRealtimeMonitoring();
    return super.close();
  }
}
