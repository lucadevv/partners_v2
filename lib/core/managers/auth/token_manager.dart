import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenTypeKey = 'token_type';

  final FlutterSecureStorage _secureStorage;

  TokenManager() : _secureStorage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
  }) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: accessToken);
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      await _secureStorage.write(key: _tokenTypeKey, value: tokenType);
    } catch (e) {
      throw Exception('Failed to save tokens: $e');
    }
  }

  Future<AuthTokens?> getTokens() async {
    try {
      final accessToken = await _secureStorage.read(key: _tokenKey);
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      final tokenType = await _secureStorage.read(key: _tokenTypeKey);

      if (accessToken == null || refreshToken == null || tokenType == null) {
        return null;
      }

      return AuthTokens(
        accessToken: accessToken!,
        refreshToken: refreshToken!,
        tokenType: tokenType!,
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> hasValidTokens() async {
    final tokens = await getTokens();
    return tokens != null;
  }

  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearTokens() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      await _secureStorage.delete(key: _tokenTypeKey);
    } catch (e) {
      throw Exception('Failed to clear tokens: $e');
    }
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });
}
