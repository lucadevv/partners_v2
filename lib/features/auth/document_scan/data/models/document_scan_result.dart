import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/ce.dart';
import 'package:partners/core/utils/models/document_identity.dart';

class DocumentScanResult {
  final DocumentIdentity document;

  final String? extractedName;
  final String? extractedLastName;
  final String? extractedBirthDate;
  final String? extractedGender;
  final String? extractedExpiryDate;

  final String rawText;
  final double confidence;

  const DocumentScanResult({
    required this.document,
    this.extractedName,
    this.extractedLastName,
    this.extractedBirthDate,
    this.extractedGender,
    this.extractedExpiryDate,
    required this.rawText,
    required this.confidence,
  });

  /// Fusiona con [other]: conserva valores de [this] cuando [other] es null.
  /// Solo para CE: acumula campos entre frames de OCR.
  DocumentScanResult mergeWith(DocumentScanResult other) {
    if (document is! Ce || other.document is! Ce) return other;

    final thisCe = document as Ce;
    final otherCe = other.document as Ce;

    final mergedExpiry = otherCe.expiryDate ?? thisCe.expiryDate;
    final mergedDoc = Ce(
      number: otherCe.number,
      type: DocumentType.ce,
      expiryDate: mergedExpiry,
    );

    return DocumentScanResult(
      document: mergedDoc,
      extractedName: other.extractedName ?? extractedName,
      extractedLastName: other.extractedLastName ?? extractedLastName,
      extractedBirthDate: other.extractedBirthDate ?? extractedBirthDate,
      extractedGender: other.extractedGender ?? extractedGender,
      extractedExpiryDate: other.extractedExpiryDate ?? extractedExpiryDate,
      rawText: other.rawText,
      confidence: other.confidence,
    );
  }
}
