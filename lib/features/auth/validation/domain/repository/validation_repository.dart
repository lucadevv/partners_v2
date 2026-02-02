import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/validation/domain/entities/email_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/otp_email_req.dart';
import 'package:partners/features/auth/validation/domain/entities/otp_whatsapp_req.dart';
import 'package:partners/features/auth/validation/domain/entities/steps_res_entity.dart';
import 'package:partners/features/auth/validation/domain/entities/whatsapp_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/whatsapp_validation_res.dart';

abstract class ValidationRepository {
  Future<Either<AppException, StepsResEntity>> getValidationSteps(
    String sessionId,
  );
  Future<Either<AppException, String>> sendEmailValidation(
    EmailValidationReq entity,
  );
  Future<Either<AppException, String>> resendEmailCode(OtpEmailReq entity);
  Future<Either<AppException, WhatsappValidationRes>> sendWhatsappValidation(
    WhatsappValidationReq entity,
  );
  Future<Either<AppException, String>> verifyWhatsappOtp(
    OtpWhatsappReq entity,
  );
}
