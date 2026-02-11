import 'package:dartz/dartz.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/exception_handler.dart';
import 'package:partners/features/auth/login/data/datasource/login_datasource.dart';
import 'package:partners/features/auth/login/data/models/login_response_model.dart';
import 'package:partners/features/auth/login/domain/entities/login_entity.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';

/// Implementación del datasource de login que llama al endpoint real.
/// Endpoint esperado: POST /auth/login con body { "email", "password" }.
/// Si tu API usa otro path o snake_case en la respuesta, ajusta aquí o en LoginResponseModel.fromJson.
class NtwLoginDatasourceImpl implements LoginDatasource {
  final ApiServices _services;

  NtwLoginDatasourceImpl({required ApiServices services})
    : _services = services;

  @override
  Future<Either<AppException, LoginResponseEntity>> login(
    LoginEntity entity,
  ) async {
    try {
      final response = await _services.post(
        '/login',
        data: <String, dynamic>{
          'email': entity.email,
          'password': entity.password,
        },
      );

      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException('Respuesta de login vacía', details: 'data is null'),
        );
      }

      final map = data is Map<String, dynamic> ? data : null;
      if (map == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de login inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }

      final model = LoginResponseModel.fromJson(map);
      return Right(model.toEntity());
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'login');
      return Left(appException);
    }
  }
}
