import 'package:dartz/dartz.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/exception_handler.dart';
import 'package:partners/features/auth/register/data/datasource/register_datasource.dart';
import 'package:partners/features/auth/register/data/models/document_res_model.dart';
import 'package:partners/features/auth/register/data/models/register_ruc_res_model.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';
import 'package:partners/features/auth/register/domain/entities/validate_ruc_entity.dart';

class NtwRegisterDatasourceImpl implements RegisterDatasource {
  final ApiServices _services;

  NtwRegisterDatasourceImpl({required ApiServices services})
    : _services = services;

  @override
  Future<Either<AppException, RegisterRucResModel>> validateComerce(
    ValidateRucEntity entity,
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
    required TipoDocumento type,
    required String number,
  }) async {
    try {
      final response = await _services.post(
        '/onboarding/lookup-document',
        data: {
          'type': type == TipoDocumento.dni ? 'dni' : 'ce',
          'number': number,
        },
      );
      final data = response.data;
      return Right(DocumentResModel.fromJson(data));
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'validateDocument');
      return Left(appException);
    }
  }
}
