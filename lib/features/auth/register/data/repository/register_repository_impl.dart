import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/data/datasource/register_datasource.dart';
import 'package:partners/features/auth/register/data/mappers/document_mapper.dart';
import 'package:partners/features/auth/register/data/mappers/register_mapper.dart';
import 'package:partners/features/auth/register/data/mappers/start_register_mapper.dart';
import 'package:partners/features/auth/register/domain/entities/rep_legal_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/request/document_rq.dart';
import 'package:partners/features/auth/register/domain/entities/request/entity_rq.dart';
import 'package:partners/features/auth/register/domain/entities/request/start_register_req.dart';
import 'package:partners/features/auth/register/domain/entities/response/start_resgister_res_entity.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDatasource _datasource;

  RegisterRepositoryImpl({required RegisterDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Either<AppException, RegisterResponseEntity>> validateComerce({
    required EntityRq entity,
  }) async {
    final response = await _datasource.validateComerce(entity);
    return response.map((model) => RegisterMapper.modelToEntity(model));
  }

  @override
  Future<Either<AppException, RepLegalResEntity>> validateDocument({
    required DocumentRq entity,
  }) async {
    final response = await _datasource.validateDocument(entity: entity);
    return response.map((model) => DocumentMapper.modelToEntity(model));
  }

  @override
  Future<Either<AppException, StartRegisterResEntity>> startRegister({
    required StartRegisterReq entity,
  }) async {
    final response = await _datasource.startRegister(entity: entity);
    return response.map((model) => StartRegisterMapper.modelToEntity(model));
  }
}
