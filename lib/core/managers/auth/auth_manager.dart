import 'package:partners/core/models/user_model.dart';

/// Manager abstracto para manejar la autenticación
abstract class AuthManager {
  /// Verifica si el usuario está logueado
  Future<bool> isUserLoggedIn();

  /// Realiza login con access y refresh token
  /// [user] información del usuario con su rol
  Future<void> login(
    String accessToken,
    String refreshToken, {
    UserModel? user,
  });

  /// Actualiza el access token
  Future<void> newAccess(String accessToken);

  /// Cierra sesión
  Future<void> logout();

  /// Maneja errores de autenticación
  Future<void> handleAuthError();

  /// Obtiene el access token actual
  Future<String?> getCurrentAccessToken();

  /// Obtiene el refresh token actual
  Future<String?> getCurrentRefreshToken();

  /// Obtiene el usuario almacenado (para restaurar RoleService al iniciar)
  Future<UserModel?> getCurrentUser();

  /// Stream de cambios en el estado de autenticación
  Stream<AuthStatus> get authStatusStream;
}

/// Estados de autenticación
enum AuthStatus {
  authenticated,
  unauthenticated,
  expired,
}
