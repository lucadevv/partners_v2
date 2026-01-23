part of 'document_scan_cubit.dart';

enum DocumentScanStatus {
  initial,
  initializingCamera,
  cameraReady,
  capturing,
  captured,
  processing,
  validating,
  validated,
  failure,
}

class DocumentScanState extends Equatable {
  final DocumentScanStatus status;
  final String? imagePath;
  final String? errorMessage;
  final DocumentScanEffect? effect;
  final DocumentOcrEntity? ocrData;
  final String? textoDetectado; // Texto completo detectado por OCR

  const DocumentScanState({
    this.status = DocumentScanStatus.initial,
    this.imagePath,
    this.errorMessage,
    this.effect,
    this.ocrData,
    this.textoDetectado,
  });

  DocumentScanState copyWith({
    DocumentScanStatus? status,
    String? imagePath,
    String? errorMessage,
    DocumentScanEffect? effect,
    DocumentOcrEntity? ocrData,
    String? textoDetectado,
  }) {
    return DocumentScanState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: errorMessage,
      effect: effect,
      ocrData: ocrData ?? this.ocrData,
      textoDetectado: textoDetectado ?? this.textoDetectado,
    );
  }

  @override
  List<Object?> get props => [
        status,
        imagePath,
        errorMessage,
        effect,
        ocrData,
        textoDetectado,
      ];
}
