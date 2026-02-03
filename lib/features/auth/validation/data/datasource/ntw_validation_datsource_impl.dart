import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/exception_handler.dart';
import 'package:partners/features/auth/validation/data/datasource/validation_datasource.dart';
import 'package:partners/features/auth/validation/data/models/steps_res_model.dart';
import 'package:partners/features/auth/validation/domain/entities/business_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/business_validation_res.dart';
import 'package:partners/features/auth/validation/domain/entities/email_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/otp_email_req.dart';
import 'package:partners/features/auth/validation/domain/entities/otp_whatsapp_req.dart';
import 'package:partners/features/auth/validation/domain/entities/password_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/password_validation_res.dart';
import 'package:partners/features/auth/validation/domain/entities/whatsapp_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/whatsapp_validation_res.dart';

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

  @override
  Future<Either<AppException, WhatsappValidationRes>> sendWhatsappValidation(
    WhatsappValidationReq entity,
  ) async {
    try {
      final response = await _services.post(
        '/onboarding/send-whatsapp-otp',
        data: entity.toJson(),
      );

      final data = WhatsappValidationRes.fromJson(response.data);
      return Right(data);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(
        appException,
        tag: 'sendWhatsappValidation',
      );
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, String>> verifyWhatsappOtp(
    OtpWhatsappReq entity,
  ) async {
    try {
      final response = await _services.post(
        '/onboarding/verify-whatsapp',
        data: entity.toJson(),
      );
      final data = response.data["message"];
      return Right(data);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'verifyWhatsappOtp');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, PasswordValidationRes>> completePassword(
    PasswordValidationReq entity,
  ) async {
    try {
      final response = await _services.post(
        '/onboarding/complete',
        data: entity.toJson(),
      );
      final data = PasswordValidationRes.fromJson(response.data);
      return Right(data);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'completePassword');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, BusinessValidationRes>> validateBusiness(
    BusinessValidationReq entity,
  ) async {
    try {
      final formData = FormData.fromMap({
        'session_id': entity.sessionId,
        'ruc_file': await MultipartFile.fromFile(
          entity.rucFile.path,
          filename: entity.rucFile.path.split('/').last,
        ),
      });

      final response = await _services.post(
        '/onboarding/validate-business',
        data: formData,
        isFormData: true,
      );

      final data = BusinessValidationRes.fromJson(response.data);
      return Right(data);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'validateBusiness');
      return Left(appException);
    }
  }
}
