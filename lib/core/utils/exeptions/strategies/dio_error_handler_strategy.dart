import 'package:dio/dio.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/strategies/error_handler_strategy.dart';
import 'package:partners/core/utils/exeptions/strategies/http_status_error_handler_strategy.dart';

class DioErrorHandlerStrategy implements ErrorHandlerStrategy {
  final HttpStatusErrorHandlerStrategy _httpStatusHandler;

  DioErrorHandlerStrategy(this._httpStatusHandler);

  @override
  bool canHandle(dynamic error) => error is DioException;

  @override
  AppException handle(dynamic error) {
    final dioError = error as DioException;

    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Tiempo de conexión agotado',
          code: 408,
        );

      case DioExceptionType.badResponse:
        return _httpStatusHandler.handle(dioError);

      case DioExceptionType.cancel:
        return NetworkException('Solicitud cancelada');

      case DioExceptionType.unknown:
        return NetworkException(
          'Error de conexión',
          details: dioError.message,
        );

      case DioExceptionType.badCertificate:
        return NetworkException('Error de certificado SSL');

      case DioExceptionType.connectionError:
        return NetworkException('Error de conexión de red');
    }
  }
}
