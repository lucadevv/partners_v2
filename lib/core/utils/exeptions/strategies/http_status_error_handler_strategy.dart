import 'package:dio/dio.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/strategies/error_handler_strategy.dart';

class HttpStatusErrorHandlerStrategy implements ErrorHandlerStrategy {
  @override
  bool canHandle(dynamic error) {
    if (error is DioException && error.type == DioExceptionType.badResponse) {
      return true;
    }
    return false;
  }

  @override
  AppException handle(dynamic error) {
    final dioError = error as DioException;
    final statusCode = dioError.response?.statusCode;
    final data = dioError.response?.data;

    switch (statusCode) {
      case 400:
        return ValidationException(
          _getErrorMessage(data, 'Solicitud incorrecta'),
          code: statusCode,
          details: _getErrorDetails(data),
        );

      case 401:
        return AuthenticationException(
          _getErrorMessage(data, 'No autorizado'),
          code: statusCode,
          details: _getErrorDetails(data),
        );

      case 403:
        return AuthenticationException(
          _getErrorMessage(data, 'Acceso denegado'),
          code: statusCode,
          details: _getErrorDetails(data),
        );

      case 404:
        return ServerException(
          _getErrorMessage(data, 'Recurso no encontrado'),
          code: statusCode,
          details: _getErrorDetails(data),
        );

      case 409:
        return ValidationException(
          _getErrorMessage(data, 'Conflicto de datos'),
          code: statusCode,
          details: _getErrorDetails(data),
        );

      case 422:
        return ValidationException(
          _getErrorMessage(data, 'Error de validación'),
          code: statusCode,
          details: _getErrorDetails(data),
        );

      case 500:
      case 502:
      case 503:
        return ServerException(
          _getErrorMessage(data, 'Error del servidor'),
          code: statusCode,
          details: _getFullResponseBody(data),
        );

      default:
        return ServerException(
          _getErrorMessage(data, 'Error del servidor'),
          code: statusCode,
          details: _getErrorDetails(data),
        );
    }
  }

  String _getErrorMessage(dynamic data, String defaultMessage) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? defaultMessage;
    }
    return defaultMessage;
  }

  String? _getErrorDetails(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['details'] ?? data['description'] ?? data['message'];
    }
    if (data != null) {
      return data.toString();
    }
    return null;
  }

  /// Para 5xx: incluir body completo en details para diagnosticar (errors, stack, etc.).
  String? _getFullResponseBody(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      return data.toString();
    }
    return data.toString();
  }
}
