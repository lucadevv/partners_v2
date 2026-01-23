import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/login/data/datasource/login_datasource.dart';
import 'package:partners/features/auth/login/domain/entities/login_entity.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';
import 'package:partners/features/auth/login/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDatasource _datasource;

  LoginRepositoryImpl({required LoginDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<AppException, LoginResponseEntity>> login(
    LoginEntity entity,
  ) {
    return _datasource.login(entity);
  }
}
