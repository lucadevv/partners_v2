import 'package:dio/dio.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/services/network/api_services.dart';

/// Clave en [RequestOptions.extra] para no añadir Authorization (p. ej. llamada a /refresh).
const String _kSkipAuthExtra = 'skipAuth';

/// Endpoint que devuelve nuevo access_token; no debe usar Bearer del access token.
const String _kRefreshPath = '/refresh';

/// Reintentos de llamada a /refresh cuando falla hasta obtener nuevo access token.
const int _kRefreshMaxRetries = 3;

/// Implementación de [ApiServices] con Dio.
/// Añade Authorization: Bearer <accessToken> en cada petición si hay token en [AuthManager].
/// Ante 401/403 o 500 por token: llama POST [/_kRefreshPath], guarda nuevo access y reintenta la petición; hasta [_kRefreshMaxRetries] reintentos de refresh.
class DioApiServicesImpl implements ApiServices {
  final Dio _dio;
  final AuthManager _authManager;

  DioApiServicesImpl(String baseUrl, AuthManager authManager)
    : _authManager = authManager,
      _dio = Dio(
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
          if (options.extra[_kSkipAuthExtra] == true) {
            return handler.next(options);
          }
          final token = await _authManager.getCurrentAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          final statusCode = e.response?.statusCode;
          final isTokenError =
              (statusCode == 401 || statusCode == 403) ||
              (statusCode == 500 && _isTokenRelatedError(e));

          if (!isTokenError) {
            return handler.next(e);
          }

          final requestPath = e.requestOptions.uri.path;
          if (requestPath.endsWith(_kRefreshPath)) {
            return handler.next(e);
          }

          final refreshToken = await _authManager.getCurrentRefreshToken();
          if (refreshToken == null || refreshToken.isEmpty) {
            await _authManager.handleAuthError();
            return handler.next(e);
          }

          for (var attempt = 1; attempt <= _kRefreshMaxRetries; attempt++) {
            try {
              final response = await _dio.post<dynamic>(
                _kRefreshPath,
                data: <String, dynamic>{'refresh_token': refreshToken},
                options: Options(
                  extra: <String, dynamic>{_kSkipAuthExtra: true},
                ),
              );
              final data = response.data;
              final newAccess = _parseAccessTokenFromResponse(data);
              if (newAccess != null && newAccess.isNotEmpty) {
                await _authManager.newAccess(newAccess);
                final opts = e.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newAccess';
                final res = await _dio.fetch<dynamic>(opts);
                return handler.resolve(
                  Response<dynamic>(
                    requestOptions: opts,
                    data: res.data,
                    statusCode: res.statusCode,
                  ),
                );
              }
            } catch (_) {
              if (attempt == _kRefreshMaxRetries) {
                await _authManager.handleAuthError();
                return handler.next(e);
              }
            }
          }
          await _authManager.handleAuthError();
          return handler.next(e);
        },
      ),
    );
  }

  /// Parsea access_token del body (acepta access_token o accessToken).
  static String? _parseAccessTokenFromResponse(dynamic data) {
    if (data is! Map) return null;
    final v = data['access_token'] ?? data['accessToken'];
    if (v is String) return v;
    return v?.toString();
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
    // Con FormData no se debe fijar Content-Type: Dio lo genera con boundary.
    final contentType = data is FormData ? null : 'application/json';
    return await _dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(contentType: contentType, headers: headers),
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
    final contentType = data is FormData ? null : 'application/json';
    return await _dio.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(contentType: contentType, headers: headers),
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
