import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/login/domain/entities/login_entity.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';

abstract class LoginDatasource {
  Future<Either<AppException, LoginResponseEntity>> login(
    LoginEntity entity,
  );
}
