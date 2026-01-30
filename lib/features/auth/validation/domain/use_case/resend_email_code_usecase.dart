import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/validation/domain/entities/otp_email_req.dart';
import 'package:partners/features/auth/validation/domain/repository/validation_repository.dart';

class ResendEmailCodeUsecase {
  final ValidationRepository _repository;

  ResendEmailCodeUsecase({required ValidationRepository repository})
    : _repository = repository;

  Future<Either<AppException, String>> call({
    required String sessionId,
    required String otp,
  }) async {
    if (sessionId.isEmpty) {
      return Left(ValidationException('Session ID cannot be empty'));
    }

    if (otp.isEmpty) {
      return Left(ValidationException('OTP cannot be empty'));
    }

    final entity = OtpEmailReq(sessionId: sessionId, otp: otp);
    return await _repository.resendEmailCode(entity);
  }
}
