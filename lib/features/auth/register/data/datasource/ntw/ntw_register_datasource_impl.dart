import 'package:dartz/dartz.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/exception_handler.dart';
import 'package:partners/features/auth/register/data/datasource/register_datasource.dart';
import 'package:partners/features/auth/register/data/models/document_res_model.dart';
import 'package:partners/features/auth/register/data/models/register_ruc_res_model.dart';
import 'package:partners/features/auth/register/data/models/start_register_res_model.dart';
import 'package:partners/features/auth/register/domain/entities/request/document_rq.dart';
import 'package:partners/features/auth/register/domain/entities/request/entity_rq.dart';
import 'package:partners/features/auth/register/domain/entities/request/start_register_req.dart';

class NtwRegisterDatasourceImpl implements RegisterDatasource {
  final ApiServices _services;

  NtwRegisterDatasourceImpl({required ApiServices services})
    : _services = services;

  @override
  Future<Either<AppException, RegisterRucResModel>> validateComerce(
    EntityRq entity,
  ) async {
    try {
      final response = await _services.post(
        '/onboarding/lookup-ruc',
        data: entity.toJson(),
      );
      final data = response.data;
      return Right(RegisterRucResModel.fromJson(data));
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'validateComerce');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, DocumentResModel>> validateDocument({
    required DocumentRq entity,
  }) async {
    try {
      final response = await _services.post(
        '/onboarding/lookup-document',
        data: entity.toJson(),
      );
      final data = response.data;
      return Right(DocumentResModel.fromJson(data));
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'validateDocument');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, StartRegisterResModel>> startRegister({
    required StartRegisterReq entity,
  }) async {
    try {
      final response = await _services.post(
        '/onboarding/start',
        data: entity.toJson(),
      );
      final data = response.data;
      return Right(StartRegisterResModel.fromJson(data));
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'startRegister');
      return Left(appException);
    }
  }
}
