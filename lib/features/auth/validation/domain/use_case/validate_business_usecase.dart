import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/validation/domain/entities/business_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/business_validation_res.dart';
import 'package:partners/features/auth/validation/domain/repository/validation_repository.dart';

class ValidateBusinessUsecase {
  final ValidationRepository _repository;

  ValidateBusinessUsecase({required ValidationRepository repository})
    : _repository = repository;

  Future<Either<AppException, BusinessValidationRes>> call({
    required String sessionId,
    required File rucFile,
  }) async {
    if (sessionId.isEmpty) {
      return Left(ValidationException("Session ID cannot be empty"));
    }
    if (!await rucFile.exists()) {
      return Left(ValidationException("El archivo no existe"));
    }
    final fileSizeInBytes = await rucFile.length();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    if (fileSizeInMB > 5) {
      return Left(ValidationException("El archivo debe ser menor a 5MB"));
    }
    final entity = BusinessValidationReq(
      sessionId: sessionId,
      rucFile: rucFile,
    );
    return await _repository.validateBusiness(entity);
  }
}
