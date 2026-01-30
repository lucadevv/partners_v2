import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/validation/domain/entities/email_validation_req.dart';
import 'package:partners/features/auth/validation/domain/repository/validation_repository.dart';
import 'package:partners/features/auth/validation/domain/validators/validator.dart';

class SendEmailValidationUsecase {
  final ValidationRepository _repository;

  SendEmailValidationUsecase({required ValidationRepository repository})
    : _repository = repository;

  Future<Either<AppException, String>> call({
    required String sessionId,
    required String email,
  }) async {
    if (sessionId.isEmpty) {
      return Left(ValidationException("Session ID cannot be empty"));
    }
    EmailValidatorStrategy validator = EmailValidatorStrategy();
    if (!validator.validate(email)) {
      return Left(ValidationException(validator.getErrorMessage()));
    }
    final entity = EmailValidationReq(sessionId: sessionId, email: email);
    return await _repository.sendEmailValidation(entity);
  }
}
