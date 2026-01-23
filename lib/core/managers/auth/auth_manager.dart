/// Manager abstracto para manejar la autenticación
abstract class AuthManager {
  /// Verifica si el usuario está logueado
  Future<bool> isUserLoggedIn();

  /// Realiza login con access y refresh token
  /// [isCompleteData] indica si el usuario ha completado todos sus datos
  Future<void> login(
    String accessToken,
    String refreshToken, {
    bool isCompleteData = false,
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

  /// Stream de cambios en el estado de autenticación
  Stream<AuthStatus> get authStatusStream;
}

/// Estados de autenticación
enum AuthStatus {
  authenticated,
  unauthenticated,
  expired,
}
