part of 'document_scan_cubit.dart';

enum DocumentScanStatus {
  initial,
  cameraReady,
  processing, // Escaneando foto final
  captured, // Éxito
  failure,
}

class DocumentScanState extends Equatable {
  final DocumentScanStatus status;
  final String? realtimeText; // Texto detectado por el stream
  final DocumentScanResult? ocrResult; // Resultado final del escaneo
  final String? errorMessage;
  final String? imagePath; // NECESARIO: Ruta de la imagen capturada

  const DocumentScanState({
    this.status = DocumentScanStatus.initial,
    this.realtimeText,
    this.ocrResult,
    this.errorMessage,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
    status,
    realtimeText,
    ocrResult,
    errorMessage,
    imagePath,
  ];

  DocumentScanState copyWith({
    DocumentScanStatus? status,
    String? realtimeText,
    DocumentScanResult? ocrResult,
    String? errorMessage,
    String? imagePath,
  }) {
    return DocumentScanState(
      status: status ?? this.status,
      realtimeText: realtimeText ?? this.realtimeText,
      ocrResult: ocrResult ?? this.ocrResult,
      errorMessage: errorMessage ?? this.errorMessage,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
