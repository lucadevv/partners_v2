/// Validador para Carné de Extranjería (CE) peruano
///
/// Implementa validaciones específicas para CE peruano:
/// - Formato: 1-3 letras seguidas de 6-9 dígitos (ej: A12345678, AB1234567)
/// - Longitud total: 9-12 caracteres
/// - Solo puede contener letras mayúsculas y números
class CeValidator {
  CeValidator._();

  /// Longitud mínima para CE peruano
  static const int _minLength = 9;

  /// Longitud máxima para CE peruano
  static const int _maxLength = 12;

  /// Valida si un número de documento es un CE válido para Perú
  ///
  /// [numeroDocumento] El número de documento a validar
  ///
  /// Retorna `true` si es válido, `false` en caso contrario
  static bool isValidCe(String? numeroDocumento) {
    if (numeroDocumento == null || numeroDocumento.isEmpty) {
      return false;
    }

    // Normalizar a mayúsculas
    final numeroNormalizado = numeroDocumento.toUpperCase().trim();

    // Validar longitud
    if (!_hasValidLength(numeroNormalizado)) {
      return false;
    }

    // Validar formato: letras seguidas de dígitos
    return _hasValidFormat(numeroNormalizado);
  }

  /// Valida si un número de documento tiene la longitud correcta
  ///
  /// [numeroDocumento] El número de documento a validar
  ///
  /// Retorna `true` si tiene la longitud correcta
  static bool _hasValidLength(String numeroDocumento) {
    return numeroDocumento.length >= _minLength &&
        numeroDocumento.length <= _maxLength;
  }

  /// Valida si un número tiene el formato correcto de CE
  ///
  /// Formato esperado: 1-3 letras seguidas de 6-9 dígitos
  /// Ejemplos válidos: A12345678, AB1234567, ABC123456
  ///
  /// [numeroDocumento] El número de documento a validar
  ///
  /// Retorna `true` si tiene el formato correcto
  static bool _hasValidFormat(String numeroDocumento) {
    // Patrón: 1-3 letras seguidas de 6-9 dígitos
    final pattern = RegExp(r'^[A-Z]{1,3}\d{6,9}$');
    return pattern.hasMatch(numeroDocumento);
  }

  /// Valida si un número de documento no está vacío
  ///
  /// [numeroDocumento] El número de documento a validar
  ///
  /// Retorna `true` si no está vacío
  static bool isNotEmpty(String? numeroDocumento) {
    return numeroDocumento != null && numeroDocumento.isNotEmpty;
  }
}
