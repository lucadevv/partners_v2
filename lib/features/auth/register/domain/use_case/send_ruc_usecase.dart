import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/request/entity_rq.dart';
import 'package:partners/features/auth/register/domain/entities/validators/ruc_validator.dart';

import 'package:partners/features/auth/register/domain/factory/ruc_config_factory.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';

class SendRucUsecase {
  final RegisterRepository _repository;

  SendRucUsecase({required RegisterRepository repository})
    : _repository = repository;

  Future<Either<AppException, RegisterResponseEntity>> call({
    required RucType type,
    required String ruc,
  }) async {
    final RucStrategy strategy = RucConfigFactory.getValidatorStrategy(type);
    if (!strategy.validate(ruc)) {
      return Left(ValidationException('Ruc no valido'));
    }
    final entity = EntityRq(ruc: ruc);
    return await _repository.validateComerce(entity: entity);
  }
}
