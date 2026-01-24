import 'package:dio/dio.dart';
import 'package:partners/core/services/network/api_services.dart';

class DioApiServicesImpl implements ApiServices {
  final Dio _dio;

  DioApiServicesImpl(String baseUrl)
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        },
        onError: (e, handler) async {
          final statusCode = e.response?.statusCode;

          final isTokenError =
              (statusCode == 401 || statusCode == 403) ||
              (statusCode == 500 && _isTokenRelatedError(e));
          if (isTokenError) {
            return;
          }

          return handler.next(e);
        },
      ),
    );
  }

  bool _isTokenRelatedError(DioException error) {
    final responseData = error.response?.data;
    final errorMessage = responseData?.toString().toLowerCase() ?? '';
    final errorHeaders = error.response?.headers.toString().toLowerCase() ?? '';

    String message = errorMessage;
    if (responseData is Map<String, dynamic>) {
      message =
          (responseData['message']?.toString().toLowerCase() ?? '') +
          (responseData['error']?.toString().toLowerCase() ?? '');
    }

    final tokenErrorKeywords = [
      'token',
      'unauthorized',
      'forbidden',
      'access token',
      'refresh token',
      'invalid token',
      'expired token',
      'token expired',
      'authentication',
      'authorization',
      'jwt',
      'jwt expired',
      'token inválido',
      'token invalido',
      'sesión expirada',
      'session expired',
      'no autorizado',
      'acceso denegado',
    ];

    final hasTokenKeyword = tokenErrorKeywords.any(
      (keyword) =>
          message.contains(keyword.toLowerCase()) ||
          errorHeaders.contains(keyword.toLowerCase()),
    );

    if (error.response?.statusCode == 500 && hasTokenKeyword) {
      return true;
    }

    return hasTokenKeyword;
  }

  @override
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return await _dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  @override
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool isFormData = false,
  }) async {
    return await _dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        contentType: isFormData ? 'multipart/form-data' : 'application/json',
        headers: headers,
      ),
    );
  }

  @override
  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool isFormData = false,
  }) async {
    return await _dio.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        contentType: isFormData ? 'multipart/form-data' : 'application/json',
        headers: headers,
      ),
    );
  }

  @override
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return await _dio.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }
}
