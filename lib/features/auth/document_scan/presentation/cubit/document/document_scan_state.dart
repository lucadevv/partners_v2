part of 'document_scan_cubit.dart';

enum DocumentScanStatus {
  initial,
  cameraReady,
  processing, // Escaneando foto final
  captured, // Éxito
  failure,
}

enum UploadIdentityStatus {
  initial,
  loading,
  success, 
  failure,
}

class DocumentScanState extends Equatable {
  final DocumentScanStatus status;
  final String? realtimeText;
  final DocumentScanResult? ocrResult;
  final String? errorMessage;
  final UploadIdentityStatus uploadStatus;

  const DocumentScanState({
    this.status = DocumentScanStatus.initial,
    this.realtimeText,
    this.ocrResult,
    this.errorMessage,
    this.uploadStatus = UploadIdentityStatus.initial,
  });

  @override
  List<Object?> get props => [
    status,
    realtimeText,
    ocrResult,
    errorMessage,
    uploadStatus,
  ];

  DocumentScanState copyWith({
    DocumentScanStatus? status,
    String? realtimeText,
    DocumentScanResult? ocrResult,
    String? errorMessage,
    UploadIdentityStatus? uploadStatus,
  }) {
    return DocumentScanState(
      status: status ?? this.status,
      realtimeText: realtimeText ?? this.realtimeText,
      ocrResult: ocrResult ?? this.ocrResult,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadStatus: uploadStatus ?? this.uploadStatus,
    );
  }
}
