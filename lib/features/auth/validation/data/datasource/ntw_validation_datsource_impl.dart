import 'package:dartz/dartz.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/exception_handler.dart';
import 'package:partners/features/auth/validation/data/datasource/validation_datasource.dart';
import 'package:partners/features/auth/validation/data/models/steps_res_model.dart';
import 'package:partners/features/auth/validation/domain/entities/email_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/otp_email_req.dart';

class NtwValidationDatsourceImpl implements ValidationDatasource {
  final ApiServices _services;

  NtwValidationDatsourceImpl({required ApiServices services})
    : _services = services;
  @override
  Future<Either<AppException, StepsResModel>> getValidationSteps(
    String sessionId,
  ) async {
    try {
      final response = await _services.post(
        '/onboarding/validate-steps',
        data: {'session_id': sessionId},
      );
      final data = response.data;
      return Right(StepsResModel.fromJson(data));
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'getValidationSteps');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, String>> sendEmailValidation(
    EmailValidationReq entity,
  ) async {
    try {
      final response = await _services.post(
        '/onboarding/send-email-otp',
        data: entity.toJson(),
      );
      print(response.data);
      final data = response.data["message"];

      return Right(data);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'sendEmailValidation');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, String>> resendEmailCode(
    OtpEmailReq entity,
  ) async {
    try {
      final response = await _services.post(
        '/onboarding/verify-email',
        data: entity.toJson(),
      );
      final data = response.data["message"];
      return Right(data);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'resendEmailCode');
      return Left(appException);
    }
  }
}
