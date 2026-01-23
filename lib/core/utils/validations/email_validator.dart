/// Validador para correos electrónicos
///
/// Implementa validaciones específicas para email:
/// - Formato válido de email
/// - No puede estar vacío
class EmailValidator {
  EmailValidator._();

  /// Valida si un email es válido
  ///
  /// [email] El email a validar
  ///
  /// Retorna `true` si es válido, `false` en caso contrario
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) {
      return false;
    }

    // Patrón de validación de email
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    );

    return emailRegex.hasMatch(email.trim());
  }

  /// Valida si un email no está vacío
  ///
  /// [email] El email a validar
  ///
  /// Retorna `true` si no está vacío
  static bool isNotEmpty(String? email) {
    return email != null && email.trim().isNotEmpty;
  }
}
