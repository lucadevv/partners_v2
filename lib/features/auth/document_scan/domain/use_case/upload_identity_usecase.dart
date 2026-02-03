import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/features/auth/document_scan/domain/repository/document_scan_repository.dart';

class UploadIdentityUsecase {
  final DocumentScanRepository _repository;

  UploadIdentityUsecase({required DocumentScanRepository repository})
      : _repository = repository;

  Future<Either<AppException, String>> call({
    required DocumentScanResult scanResult,
  }) async {
    if (scanResult.document.number.isEmpty) {
      return Left(ValidationException('El número de documento no puede estar vacío'));
    }

    return await _repository.uploadIdentity(scanResult: scanResult);
  }
}
