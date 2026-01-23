import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/login/domain/entities/login_entity.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';
import 'package:partners/features/auth/login/domain/repository/login_repository.dart';

class LoginUsecase {
  final LoginRepository _repository;

  LoginUsecase({required LoginRepository repository})
      : _repository = repository;

  Future<Either<AppException, LoginResponseEntity>> login(
    LoginEntity entity,
  ) async {
    return await _repository.login(entity);
  }
}
