import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/data/datasource/register_datasource.dart';
import 'package:partners/features/auth/register/domain/entities/register_entity.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDatasource _registerDatasource;

  RegisterRepositoryImpl({
    required RegisterDatasource registerDatasource,
  }) : _registerDatasource = registerDatasource;
  @override
  Future<Either<AppException, RegisterResponseEntity>> validateComerce({
    required RegisterEntity entity,
  }) {
    return _registerDatasource
        .validateComerce<RegisterEntity, RegisterResponseEntity>(entity);
  }
}
