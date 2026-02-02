import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/features/auth/document_scan/domain/repository/document_scan_repository.dart';

class OcrUsecase {
  final DocumentScanRepository _repository;

  OcrUsecase({required DocumentScanRepository repository})
    : _repository = repository;

  Future<Either<AppException, DocumentScanResult>> call({
    required String imagePath,
  }) async {
    if (imagePath.isEmpty) {
      return Left(ValidationException('La imagen no puede ser nula'));
    }
    return await _repository.ocrData(imagePath: imagePath);
  }
}
