import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:partners/core/models/user_model.dart';

/// Manager para almacenar y recuperar tokens y usuario de forma segura
class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user';

  final FlutterSecureStorage _storage;

  TokenManager({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Guarda los tokens y opcionalmente el usuario (para restaurar rol al reabrir la app)
  Future<void> saveToken(
    String accessToken,
    String refreshToken, {
    UserModel? user,
  }) async {
    final writes = <Future<void>>[
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ];
    if (user != null) {
      writes.add(
        _storage.write(key: _userKey, value: jsonEncode(user.toJson())),
      );
    }
    await Future.wait(writes);
  }

  /// Actualiza solo el access token
  Future<void> updateAccess(String accessToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  /// Elimina todos los tokens y el usuario almacenado
  Future<void> deleteToken() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userKey),
    ]);
  }

  /// Obtiene el usuario almacenado (para restaurar RoleService al iniciar la app)
  Future<UserModel?> getStoredUser() async {
    final json = await _storage.read(key: _userKey);
    if (json == null || json.isEmpty) return null;
    try {
      return UserModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(json) as Map),
      );
    } catch (_) {
      return null;
    }
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
}
