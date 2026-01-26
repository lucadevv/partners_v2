import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/data/datasource/register_datasource.dart';
import 'package:partners/features/auth/register/data/mappers/document_mapper.dart';
import 'package:partners/features/auth/register/data/mappers/register_mapper.dart';
import 'package:partners/features/auth/register/domain/entities/document_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';
import 'package:partners/features/auth/register/domain/entities/validate_ruc_entity.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDatasource _registerDatasource;

  RegisterRepositoryImpl({required RegisterDatasource registerDatasource})
      : _registerDatasource = registerDatasource;

  @override
  Future<Either<AppException, RegisterResponseEntity>> validateComerce({
    required ValidateRucEntity entity,
  }) async {
    final response = await _registerDatasource.validateComerce(entity);
    return response.map((model) => RegisterMapper.modelToEntity(model));
  }

  @override
  Future<Either<AppException, DocumentResponseEntity>> validateDocument({
    required TipoDocumento type,
    required String number,
  }) async {
    final response = await _registerDatasource.validateDocument(
      type: type,
      number: number,
    );
    return response.map((model) => DocumentMapper.modelToEntity(model));
  }
}
