import 'package:partners/core/utils/models/document_identity.dart';

class DocumentScanResult {
  final DocumentIdentity document;

  final String? extractedName;
  final String? extractedLastName;
  final String? extractedBirthDate;
  final String? extractedGender;

  final String rawText;
  final double confidence;

  const DocumentScanResult({
    required this.document,
    this.extractedName,
    this.extractedLastName,
    this.extractedBirthDate,
    this.extractedGender,
    required this.rawText,
    required this.confidence,
  });
}
