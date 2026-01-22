import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/data/datasource/register_datasource.dart';
import 'package:partners/features/auth/register/data/models/register_response_model.dart';
import 'package:partners/features/auth/register/domain/entities/register_entity.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_comercio.dart';

/// Mock Datasource para registro - Simula llamadas al backend
class RegisterMockDatasource implements RegisterDatasource {
  @override
  Future<Either<AppException, TResponse>> validateComerce<TRequest, TResponse>(
    TRequest request,
  ) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    try {
      if (request is! RegisterEntity) {
        return Left(
          ServerException('Invalid request type'),
        );
      }

      final entity = request;

      // Validar número de documento
      final numeroDocumento = entity.numeroDocumento ?? '';
      if (numeroDocumento.length < 8) {
        return Left(
          ServerException('Número de documento inválido'),
        );
      }

      // Generar respuesta según tipo de comercio
      final response = _generateResponse(entity);

      return Right(response as TResponse);
    } catch (e) {
      return Left(
        ServerException(
          'Error al validar comercio: ${e.toString()}',
        ),
      );
    }
  }

  RegisterResponseModel _generateResponse(RegisterEntity entity) {
    final tipoComercio = entity.tipoComercio;

    // Para RUC 20: retornar razón social
    if (tipoComercio == TipoComercio.ruc20) {
      return const RegisterResponseModel(razonSocial: 'MARKETRIX S.A.C.');
    }

    // Para RUC 10 y 15: retornar nombres y apellidos
    if (tipoComercio == TipoComercio.ruc10 || tipoComercio == TipoComercio.ruc15) {
      return const RegisterResponseModel(
        nombres: 'Anderson J.',
        apellidos: 'Moscol Sicha',
      );
    }

    // Por defecto
    return const RegisterResponseModel(
      nombres: 'Usuario',
      apellidos: 'Prueba',
    );
  }

  /// Datos mock para testing
  static Map<String, RegisterResponseModel> get mockData => {
    '10733456723': const RegisterResponseModel(
      nombres: 'Anderson J.',
      apellidos: 'Moscol Sicha',
    ),
    '15023303493': const RegisterResponseModel(
      nombres: 'Kary M.',
      apellidos: 'Tapia Ronzoco',
    ),
    '20605999558': const RegisterResponseModel(razonSocial: 'MARKETRIX S.A.C.'),
    '20605866744': const RegisterResponseModel(
      razonSocial: 'TECH SOLUTIONS S.A.C.',
    ),
  };

  /// Obtener datos mock por documento
  static RegisterResponseModel? getMockByDocument(String document) {
    return mockData[document];
  }
}
