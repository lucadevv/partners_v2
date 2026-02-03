import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/validation/domain/entities/password_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/password_validation_res.dart';
import 'package:partners/features/auth/validation/domain/repository/validation_repository.dart';

class CompletePasswordUsecase {
  final ValidationRepository _repository;

  CompletePasswordUsecase({required ValidationRepository repository})
      : _repository = repository;

  Future<Either<AppException, PasswordValidationRes>> call({
    required String sessionId,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (sessionId.isEmpty) {
      return Left(ValidationException('Session ID no puede estar vacío'));
    }

    if (password.isEmpty) {
      return Left(ValidationException('La contraseña no puede estar vacía'));
    }

    if (passwordConfirmation.isEmpty) {
      return Left(
          ValidationException('La confirmación de contraseña no puede estar vacía'));
    }

    if (password != passwordConfirmation) {
      return Left(
          ValidationException('Las contraseñas no coinciden'));
    }

    final req = PasswordValidationReq(
      sessionId: sessionId,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    return await _repository.completePassword(req);
  }
}
