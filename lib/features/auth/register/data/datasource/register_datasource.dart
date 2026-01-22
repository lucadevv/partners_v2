import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';

/// Datasource genérico para registro
///
/// Permite usar cualquier tipo para request y response
abstract class RegisterDatasource {
  Future<Either<AppException, TResponse>> validateComerce<TRequest, TResponse>(
    TRequest request,
  );
}
