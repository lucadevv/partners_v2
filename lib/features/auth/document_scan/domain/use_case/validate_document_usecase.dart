import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_ocr_entity.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_validation_response_entity.dart';
import 'package:partners/features/auth/document_scan/domain/repository/document_scan_repository.dart';

class ValidateDocumentUsecase {
  final DocumentScanRepository _repository;

  ValidateDocumentUsecase({required DocumentScanRepository repository})
      : _repository = repository;

  Future<Either<AppException, DocumentValidationResponseEntity>> validateDocument({
    required DocumentOcrEntity ocrData,
  }) async {
    return await _repository.validateDocument(ocrData: ocrData);
  }
}
