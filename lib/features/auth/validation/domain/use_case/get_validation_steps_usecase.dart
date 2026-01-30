import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/validation/domain/entities/steps_res_entity.dart';
import 'package:partners/features/auth/validation/domain/repository/validation_repository.dart';

class GetValidationStepsUsecase {
  final ValidationRepository _repository;

  GetValidationStepsUsecase({required ValidationRepository repository})
    : _repository = repository;

  Future<Either<AppException, StepsResEntity>> call(String sessionId) async {
    if (sessionId.isEmpty) {
      return Left(
        ValidationException('El sessionId no puede ser nulo o vacío'),
      );
    }
    return await _repository.getValidationSteps(sessionId);
  }
}
