import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manager para almacenar y recuperar tokens de forma segura
class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _isCompleteDataKey = 'is_complete_data';

  final FlutterSecureStorage _storage;

  TokenManager({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Guarda los tokens
  Future<void> saveToken(
    String accessToken,
    String refreshToken, {
    bool? isCompleteData,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
      if (isCompleteData != null)
        _storage.write(
          key: _isCompleteDataKey,
          value: isCompleteData.toString(),
        ),
    ]);
  }

  /// Actualiza solo el access token
  Future<void> updateAccess(String accessToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  /// Elimina todos los tokens
  Future<void> deleteToken() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _isCompleteDataKey),
    ]);
  }

  /// Verifica si hay tokens guardados
  Future<bool> hasToken() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    return refreshToken != null && refreshToken.isNotEmpty;
  }

  /// Obtiene el access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Obtiene el refresh token
  Future<String?> getResfreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Obtiene el estado de datos completos
  Future<bool> getIsCompleteData() async {
    final value = await _storage.read(key: _isCompleteDataKey);
    return value == 'true';
  }

  /// Actualiza el estado de datos completos
  Future<void> setIsCompleteData(bool isComplete) async {
    await _storage.write(
      key: _isCompleteDataKey,
      value: isComplete.toString(),
    );
  }
}
