import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/domain/entities/register_entity.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';

abstract class RegisterRepository {
  Future<Either<AppException, RegisterResponseEntity>> validateComerce({
    required RegisterEntity entity,
  });
}
