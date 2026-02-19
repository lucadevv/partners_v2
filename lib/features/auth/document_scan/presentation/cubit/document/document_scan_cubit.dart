import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/core/utils/models/ce.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/features/auth/document_scan/domain/parser/dni_parser.dart';
import 'package:partners/features/auth/document_scan/domain/parser/ce_parser.dart';
import 'package:partners/features/auth/document_scan/domain/parser/document_parser.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/ocr_usecase.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/upload_identity_usecase.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/watch_document_realt_time_usecase.dart';

part 'document_scan_state.dart';

class DocumentScanCubit extends Cubit<DocumentScanState> {
  final OcrUsecase _ocrUsecase;
  final WatchDocumentRealtTimeUsecase _watchDocumentRealtTimeUsecase;
  final UploadIdentityUsecase _uploadIdentityUsecase;
  List<DocumentParser> _parsers = [];

  StreamSubscription<Either<AppException, String>>? _realtimeSubscription;
  Timer? _errorResetTimer;
  int _retryCount = 0;
  static const int _maxRetries = 10;

  /// Acumula campos CE entre frames: no sobrescribe con null.
  DocumentScanResult? _accumulatedCeResult;

  DocumentScanCubit({
    required OcrUsecase ocrUsecase,
    required WatchDocumentRealtTimeUsecase watchDocumentRealtTimeUsecase,
    required UploadIdentityUsecase uploadIdentityUsecase,
  }) : _ocrUsecase = ocrUsecase,
       _watchDocumentRealtTimeUsecase = watchDocumentRealtTimeUsecase,
       _uploadIdentityUsecase = uploadIdentityUsecase,
       super(const DocumentScanState());

  void initializeRucType(RucType rucType) {
    _parsers = _getParsersForRucType(rucType);
  }

  List<DocumentParser> _getParsersForRucType(RucType rucType) {
    switch (rucType) {
      case RucType.ruc10:
        return [DniParser()];
      case RucType.ruc15:
        return [CeParser()];
      case RucType.ruc20:
        return [DniParser(), CeParser()];
    }
  }

  void startRealtimeMonitoring(CameraController cameraController) {
    if (state.status == DocumentScanStatus.processing) return;

    if (isClosed) {
      return;
    }

    stopRealtimeMonitoring();
    _retryCount = 0;
    _accumulatedCeResult = null;

    if (!isClosed) {
      emit(state.copyWith(status: DocumentScanStatus.cameraReady));
    }

    _realtimeSubscription =
        _watchDocumentRealtTimeUsecase(
          cameraController: cameraController,
          interval: const Duration(seconds: 3),
        ).listen(
          (result) {
            if (isClosed) {
              return;
            }

            result.fold(
              (failure) {
                _retryCount++;
                if (_retryCount >= _maxRetries) {
                  stopRealtimeMonitoring();
                  if (!isClosed) {
                    emit(
                      state.copyWith(
                        status: DocumentScanStatus.failure,
                        errorMessage:
                            'No se pudo leer el documento. Asegúrate de mantener el teléfono quieto y que haya buena iluminación.',
                      ),
                    );
                    _startErrorResetTimer();
                  }
                }
              },
              (detectedText) {
                final isCeFlow =
                    _parsers.isNotEmpty && _parsers.any((p) => p is CeParser);
                // Debug: texto crudo que ve la cámara (realtime OCR, antes del parse).
                if (isCeFlow) {
                  debugPrint(
                    'lucadev [CE] REALTIME OCR camera raw (${detectedText.length} chars): $detectedText',
                  );
                }

                if (_parsers.isEmpty) return;

                final textUpperCase = detectedText.toUpperCase();

                DocumentScanResult? parsedResult;
                for (final parser in _parsers) {
                  parsedResult = parser.parse(textUpperCase);
                  if (parsedResult != null) {
                    break;
                  }
                }

                if (parsedResult != null &&
                    parsedResult.document is Ce &&
                    isCeFlow) {
                  _accumulatedCeResult = _accumulatedCeResult != null
                      ? _smartMergeCe(_accumulatedCeResult!, parsedResult)
                      : parsedResult;
                  parsedResult = _accumulatedCeResult!;
                  final ce = parsedResult.document as Ce;
                  debugPrint(
                    'lucadev [CE] accumulated: number=${ce.number} surnames=${parsedResult.extractedLastName} names=${parsedResult.extractedName} dob=${parsedResult.extractedBirthDate} expiry=${ce.expiryDate}',
                  );
                }

                if (parsedResult != null) {
                  final isComplete = _isDocumentComplete(parsedResult);
                  if (parsedResult.document is Ce && isCeFlow) {
                    debugPrint('lucadev [CE] isComplete=$isComplete');
                  }

                  if (isComplete) {
                    stopRealtimeMonitoring();
                    _retryCount = 0;

                    final expired = _isDocumentExpired(parsedResult);
                    if (expired) {
                      if (!isClosed) {
                        emit(
                          state.copyWith(
                            status: DocumentScanStatus.failure,
                            errorMessage:
                                'El documento está vencido. Por favor, utiliza un documento vigente.',
                            ocrResult: parsedResult,
                          ),
                        );
                        _startErrorResetTimer();
                      }
                      return;
                    }

                    _accumulatedCeResult = null;
                    _uploadIdentityToBackend(parsedResult);
                    return;
                  } else {
                    _retryCount++;
                    if (_retryCount >= _maxRetries) {
                      stopRealtimeMonitoring();
                      if (!isClosed) {
                        emit(
                          state.copyWith(
                            status: DocumentScanStatus.failure,
                            errorMessage:
                                'No se pudo leer completamente el documento. Asegúrate de mantener el teléfono quieto y que el documento esté bien iluminado.',
                            ocrResult: parsedResult,
                          ),
                        );
                        _startErrorResetTimer();
                      }
                      return;
                    }
                  }
                } else {
                  _retryCount++;
                  if (_retryCount >= _maxRetries) {
                    stopRealtimeMonitoring();
                    if (!isClosed) {
                      emit(
                        state.copyWith(
                          status: DocumentScanStatus.failure,
                          errorMessage:
                              'No se pudo reconocer el documento. Asegúrate de mantener el teléfono quieto y que haya buena iluminación.',
                        ),
                      );
                      _startErrorResetTimer();
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
                }
              },
            );
          },
          onError: (error) {},
          onDone: () {},
        );
  }

  void stopRealtimeMonitoring() {
    _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
  }

  void _startErrorResetTimer() {
    _errorResetTimer?.cancel();

    _errorResetTimer = Timer(const Duration(seconds: 10), () {
      if (!isClosed) {
        emit(
          const DocumentScanState(
            status: DocumentScanStatus.initial,
            errorMessage: null,
            ocrResult: null,
            realtimeText: null,
            uploadStatus: UploadIdentityStatus.initial,
          ),
        );

        _retryCount = 0;
      }
    });
  }

  Future<void> captureAndProcessImage(String imagePath) async {
    if (state.status == DocumentScanStatus.processing) return;
    if (isClosed) {
      return;
    }

    stopRealtimeMonitoring();

    if (!isClosed) {
      emit(
        state.copyWith(
          status: DocumentScanStatus.processing,
          errorMessage: null,
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
          _startErrorResetTimer();
        }
      },
      (scanResult) {
        final isComplete = _isDocumentComplete(scanResult);
        if (isComplete) {
          if (_isDocumentExpired(scanResult)) {
            if (!isClosed) {
              emit(
                state.copyWith(
                  status: DocumentScanStatus.failure,
                  errorMessage:
                      'El documento está vencido. Por favor, utiliza un documento vigente.',
                  ocrResult: scanResult,
                ),
              );
              _startErrorResetTimer();
            }
            return;
          }

          _uploadIdentityToBackend(scanResult);
        } else {
          if (!isClosed) {
            emit(
              state.copyWith(
                status: DocumentScanStatus.processing,
                ocrResult: scanResult,
                realtimeText: null,
                uploadStatus: UploadIdentityStatus.initial,
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _uploadIdentityToBackend(DocumentScanResult scanResult) async {
    if (isClosed) return;

    if (!isClosed) {
      emit(
        state.copyWith(
          status: DocumentScanStatus.processing,
          ocrResult: scanResult,
          realtimeText: null,
          uploadStatus: UploadIdentityStatus.loading,
        ),
      );
    }

    final result = await _uploadIdentityUsecase(scanResult: scanResult);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DocumentScanStatus.failure,
            errorMessage: 'Error al subir documento: ${failure.message}',
            uploadStatus: UploadIdentityStatus.failure,
          ),
        );
        _startErrorResetTimer();
      },
      (message) {
        emit(
          state.copyWith(
            status: DocumentScanStatus.captured,
            ocrResult: scanResult,
            realtimeText: null,
            uploadStatus: UploadIdentityStatus.success,
          ),
        );
      },
    );
  }

  void reset() {
    stopRealtimeMonitoring();
    _errorResetTimer?.cancel();
    _errorResetTimer = null;
    _accumulatedCeResult = null;
    emit(const DocumentScanState());
  }

  void retry() {
    _errorResetTimer?.cancel();
    _errorResetTimer = null;
    _retryCount = 0;
    _accumulatedCeResult = null;
    emit(
      state.copyWith(
        status: DocumentScanStatus.cameraReady,
        errorMessage: null,
        ocrResult: null,
        realtimeText: null,
        uploadStatus: UploadIdentityStatus.initial,
      ),
    );
  }

  /// Merge CE: no sobrescribe datos buenos con basura OCR; prefiere fecha de caducidad posterior.
  DocumentScanResult _smartMergeCe(
    DocumentScanResult accumulated,
    DocumentScanResult other,
  ) {
    final accCe = accumulated.document as Ce;
    final otherCe = other.document as Ce;

    // Expiry: preferir la fecha con año mayor (Caducidad > Emisión).
    String? bestExpiry = otherCe.expiryDate ?? accCe.expiryDate;
    if (accCe.expiryDate != null && otherCe.expiryDate != null) {
      final accYear = _yearFromDateStr(accCe.expiryDate!);
      final otherYear = _yearFromDateStr(otherCe.expiryDate!);
      bestExpiry = accYear >= otherYear ? accCe.expiryDate : otherCe.expiryDate;
    }

    // Nombres/apellidos: solo aceptar nuevo valor si parece válido; si no, conservar acumulado.
    // No aceptar nombres que sean iguales a apellidos en este frame (OCR a veces repite apellidos en nombres).
    final mergedLastName =
        CeParser.looksLikeValidPersonName(other.extractedLastName)
        ? (other.extractedLastName ?? accumulated.extractedLastName)
        : accumulated.extractedLastName;
    final otherName = other.extractedName;
    final nameEqualsLastNameInFrame = otherName != null &&
        other.extractedLastName != null &&
        otherName.trim().toUpperCase() == other.extractedLastName!.trim().toUpperCase();
    final mergedName = !nameEqualsLastNameInFrame &&
            CeParser.looksLikeValidPersonName(otherName)
        ? (otherName ?? accumulated.extractedName)
        : accumulated.extractedName;

    final mergedDoc = Ce(
      number: otherCe.number,
      type: DocumentType.ce,
      expiryDate: bestExpiry,
    );

    return DocumentScanResult(
      document: mergedDoc,
      extractedName: mergedName,
      extractedLastName: mergedLastName,
      extractedBirthDate:
          other.extractedBirthDate ?? accumulated.extractedBirthDate,
      extractedGender: other.extractedGender ?? accumulated.extractedGender,
      extractedExpiryDate: bestExpiry,
      rawText: other.rawText,
      confidence: other.confidence,
    );
  }

  int _yearFromDateStr(String ddMmYyyy) {
    final parts = ddMmYyyy.split('/');
    if (parts.length >= 3) {
      return int.tryParse(parts[2]) ?? 0;
    }
    return 0;
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

    if (result.document is Ce) {
      // CE: requiere número, apellidos, nombres, fecha nacimiento y caducidad. Género opcional.
      final ce = result.document as Ce;
      final hasExpiry = ce.expiryDate != null && ce.expiryDate!.isNotEmpty;
      return hasName && hasLastName && hasBirthDate && hasExpiry;
    }

    return hasName && hasLastName && hasBirthDate && hasGender;
  }

  bool _isDocumentExpired(DocumentScanResult result) {
    if (result.document is Dni) {
      final dni = result.document as Dni;
      return dni.expiryDate != null &&
          dni.expiryDate!.isNotEmpty &&
          dni.isExpired();
    }
    if (result.document is Ce) {
      final ce = result.document as Ce;
      return ce.expiryDate != null &&
          ce.expiryDate!.isNotEmpty &&
          ce.isExpired();
    }
    return false;
  }

  @override
  Future<void> close() {
    stopRealtimeMonitoring();
    _errorResetTimer?.cancel();
    _errorResetTimer = null;
    return super.close();
  }
}
