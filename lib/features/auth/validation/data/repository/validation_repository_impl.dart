import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/validation/data/datasource/validation_datasource.dart';
import 'package:partners/features/auth/validation/data/mappers/validation_mapper.dart';
import 'package:partners/features/auth/validation/domain/entities/email_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/otp_email_req.dart';
import 'package:partners/features/auth/validation/domain/entities/steps_res_entity.dart';
import 'package:partners/features/auth/validation/domain/repository/validation_repository.dart';

class ValidationRepositoryImpl implements ValidationRepository {
  final ValidationDatasource _datasource;

  ValidationRepositoryImpl({required ValidationDatasource datasource})
    : _datasource = datasource;
  @override
  Future<Either<AppException, StepsResEntity>> getValidationSteps(
    String sessionId,
  ) async {
    final response = await _datasource.getValidationSteps(sessionId);
    return response.map((model) => ValidationMapper.mapToEntity(model));
  }

  @override
  Future<Either<AppException, String>> sendEmailValidation(
    EmailValidationReq entity,
  ) async {
    return await _datasource.sendEmailValidation(entity);
  }

  @override
  Future<Either<AppException, String>> resendEmailCode(
    OtpEmailReq entity,
  ) async {
    return await _datasource.resendEmailCode(entity);
  }
}
