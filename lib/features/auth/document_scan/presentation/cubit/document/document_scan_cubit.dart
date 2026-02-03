import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
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
                final textUpperCase = detectedText.toUpperCase();

                if (_parsers.isEmpty) {
                  return;
                }

                DocumentScanResult? parsedResult;
                for (final parser in _parsers) {
                  parsedResult = parser.parse(textUpperCase);
                  if (parsedResult != null) {
                    break;
                  }
                }

                if (parsedResult != null) {
                  final isComplete = _isDocumentComplete(parsedResult);

                  if (isComplete) {
                    stopRealtimeMonitoring();
                    _retryCount = 0;

                    if (parsedResult.document is Dni) {
                      final dni = parsedResult.document as Dni;

                      if (dni.expiryDate != null &&
                          dni.expiryDate!.isNotEmpty) {
                        final isExpired = dni.isExpired();

                        if (isExpired) {
                          if (!isClosed) {
                            stopRealtimeMonitoring();
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
                      } else {}
                    }

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
          if (scanResult.document is Dni) {
            final dni = scanResult.document as Dni;

            if (dni.expiryDate != null && dni.expiryDate!.isNotEmpty) {
              final isExpired = dni.isExpired();

              if (isExpired) {
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
            } else {}
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
    emit(const DocumentScanState());
  }

  void retry() {
    _errorResetTimer?.cancel();
    _errorResetTimer = null;
    _retryCount = 0;
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

    return hasName && hasLastName && hasBirthDate && hasGender;
  }

  @override
  Future<void> close() {
    stopRealtimeMonitoring();
    _errorResetTimer?.cancel();
    _errorResetTimer = null;
    return super.close();
  }
}
