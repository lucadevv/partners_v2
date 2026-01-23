import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/auth/document_scan/data/services/ocr_service.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_ocr_entity.dart';
import 'package:partners/features/auth/document_scan/domain/repository/document_scan_repository.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/process_document_ocr_usecase.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/validate_document_usecase.dart';
import 'package:partners/main.dart';

part 'document_scan_state.dart';
part 'document_scan_effect.dart';

/// Cubit para manejar el escaneo de documento de identidad
class DocumentScanCubit extends Cubit<DocumentScanState> with BaseCubitMixin {
  final ProcessDocumentOcrUsecase _processDocumentOcrUsecase;
  final ValidateDocumentUsecase _validateDocumentUsecase;

  DocumentScanCubit({
    ProcessDocumentOcrUsecase? processDocumentOcrUsecase,
    ValidateDocumentUsecase? validateDocumentUsecase,
  })  : _processDocumentOcrUsecase =
            processDocumentOcrUsecase ??
            (getIt.isRegistered<ProcessDocumentOcrUsecase>()
                ? getIt<ProcessDocumentOcrUsecase>()
                : ProcessDocumentOcrUsecase()),
        _validateDocumentUsecase =
            validateDocumentUsecase ??
            (getIt.isRegistered<ValidateDocumentUsecase>()
                ? getIt<ValidateDocumentUsecase>()
                : ValidateDocumentUsecase(
                    repository: getIt.isRegistered<DocumentScanRepository>()
                        ? getIt<DocumentScanRepository>()
                        : throw Exception(
                            'DocumentScanRepository no está registrado en GetIt',
                          ),
                  )),
      super(
        const DocumentScanState(status: DocumentScanStatus.initializingCamera),
      );

  /// Notifica que la cámara está inicializada y lista
  void cameraInitialized() {
    emit(state.copyWith(status: DocumentScanStatus.cameraReady));
  }

  /// Obtiene el texto crudo del OCR sin procesar el documento completo
  /// Útil para análisis en tiempo real
  Future<String?> getRawTextFromImage(String imagePath) async {
    try {
      debugPrint('🔍 [Cubit] Obteniendo texto crudo de: $imagePath');
      final ocrService = OcrService();
      final texto = await ocrService.getRawText(imagePath);
      debugPrint('✅ [Cubit] Texto obtenido: ${texto.length} caracteres');
      return texto;
    } catch (e, stackTrace) {
      debugPrint('❌ [Cubit] Error al obtener texto: $e');
      debugPrint('📚 Stack trace: $stackTrace');
      return null;
    }
  }

  /// Actualiza solo el texto detectado sin cambiar el estado principal
  /// Útil para mostrar texto en tiempo real mientras se analiza
  void updateDetectedText(String texto) {
    if (state.status == DocumentScanStatus.cameraReady ||
        state.status == DocumentScanStatus.initializingCamera ||
        state.status == DocumentScanStatus.processing) {
      emit(state.copyWith(textoDetectado: texto));
    }
  }

  /// Procesa una imagen de documento con OCR
  Future<void> processDocumentImage(String imagePath) async {
    if (state.status == DocumentScanStatus.processing) {
      return;
    }

    emit(
      state.copyWith(
        status: DocumentScanStatus.processing,
        imagePath: imagePath,
        textoDetectado: null, // Limpiar texto anterior
      ),
    );

    // Primero, obtener el texto crudo del OCR para mostrarlo siempre
    String? textoCrudo;
    try {
      final ocrService = OcrService();
      textoCrudo = await ocrService.getRawText(imagePath);
    } catch (e) {
      // Si falla obtener el texto crudo, continuar de todas formas
    }

    final result = await _processDocumentOcrUsecase.execute(
      imagePath: imagePath,
    );

    result.fold(
      (failure) {
        String errorMessage = getErrorMessage(failure);
        // Usar el texto crudo si está disponible, o intentar extraerlo del error
        String? textoParaMostrar = textoCrudo;
        if (textoParaMostrar == null &&
            errorMessage.contains('Texto detectado:')) {
          final partes = errorMessage.split('Texto detectado:');
          if (partes.length > 1) {
            textoParaMostrar = partes[1].trim();
          }
        }
        emit(
          state.copyWith(
            status: DocumentScanStatus.failure,
            errorMessage: errorMessage
                .split('\n\nTexto detectado:')
                .first, // Solo el mensaje de error
            textoDetectado:
                textoParaMostrar, // Mostrar texto detectado incluso en error
          ),
        );
      },
      (ocrData) {
        emit(
          state.copyWith(
            status: DocumentScanStatus.captured,
            ocrData: ocrData,
            textoDetectado: ocrData
                .textoCompleto, // Guardar texto completo para mostrar en UI
          ),
        );
      },
    );
  }

  /// Valida el documento capturado después del OCR
  Future<void> validateDocument() async {
    if (state.ocrData == null) {
      emit(
        state.copyWith(
          status: DocumentScanStatus.failure,
          errorMessage: 'No hay datos OCR para validar',
        ),
      );
      return;
    }

    emit(state.copyWith(status: DocumentScanStatus.validating));

    final response = await _validateDocumentUsecase.validateDocument(
      ocrData: state.ocrData!,
    );

    response.fold(
      (failure) {
        String errorMessage = getErrorMessage(failure);
        emit(
          state.copyWith(
            status: DocumentScanStatus.failure,
            errorMessage: errorMessage,
          ),
        );
      },
      (validationResponse) {
        if (validationResponse.isValid) {
          emit(
            state.copyWith(
              status: DocumentScanStatus.validated,
              effect: const DocumentValidatedEffect(),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: DocumentScanStatus.failure,
              errorMessage: validationResponse.message ?? 'Documento no válido',
            ),
          );
        }
      },
    );
  }

  /// Reintentar captura
  void retryCapture() {
    emit(
      state.copyWith(
        status: DocumentScanStatus.cameraReady,
        imagePath: null,
        errorMessage: null,
        ocrData: null,
        textoDetectado: null,
      ),
    );
  }

  /// Navegar a siguiente pantalla
  void navigateToNext() {
    emit(state.copyWith(effect: const NavigateToBusinessValidationEffect()));
  }

  /// Limpia el effect después de procesarlo
  void clearEffect() {
    emit(state.copyWith(effect: null));
  }

  /// Reset del estado
  void reset() {
    emit(const DocumentScanState());
  }
}
