import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/validate_ruc_entity.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';

class ValidateCommerceUsecase {
  final RegisterRepository _repository;

  ValidateCommerceUsecase({required RegisterRepository repository})
      : _repository = repository;

  Future<Either<AppException, RegisterResponseEntity>> validateComerce({
    required ValidateRucEntity entity,
  }) async {
    return await _repository.validateComerce(entity: entity);
  }
}
