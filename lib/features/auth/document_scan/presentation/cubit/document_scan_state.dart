part of 'document_scan_cubit.dart';

enum DocumentScanStatus {
  initial,
  capturing,
  captured,
  validating,
  validated,
  failure,
}

class DocumentScanState extends Equatable {
  final DocumentScanStatus status;
  final String? imagePath;
  final String? errorMessage;
  final DocumentScanEffect? effect;

  const DocumentScanState({
    this.status = DocumentScanStatus.initial,
    this.imagePath,
    this.errorMessage,
    this.effect,
  });

  DocumentScanState copyWith({
    DocumentScanStatus? status,
    String? imagePath,
    String? errorMessage,
    DocumentScanEffect? effect,
  }) {
    return DocumentScanState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: errorMessage,
      effect: effect,
    );
  }

  @override
  List<Object?> get props => [
        status,
        imagePath,
        errorMessage,
        effect,
      ];
}
