/// Validador para documentos de identidad peruanos (DNI)
///
/// Implementa validaciones específicas para DNI peruano:
/// - Debe tener exactamente 8 dígitos
/// - Solo puede contener números
/// - No puede estar vacío
class DniValidator {
  DniValidator._();

  /// Longitud válida para DNI peruano
  static const int _dniLength = 8;

  /// Valida si un número de documento es un DNI válido para Perú
  ///
  /// [numeroDocumento] El número de documento a validar
  ///
  /// Retorna `true` si es válido, `false` en caso contrario
  static bool isValidDni(String? numeroDocumento) {
    if (numeroDocumento == null || numeroDocumento.isEmpty) {
      return false;
    }

    return _hasValidLength(numeroDocumento) && _containsOnlyDigits(numeroDocumento);
  }

  /// Valida si un número de documento tiene la longitud correcta
  ///
  /// [numeroDocumento] El número de documento a validar
  ///
  /// Retorna `true` si tiene la longitud correcta
  static bool _hasValidLength(String numeroDocumento) {
    return numeroDocumento.length == _dniLength;
  }

  /// Valida si un número contiene solo dígitos
  ///
  /// [numeroDocumento] El número de documento a validar
  ///
  /// Retorna `true` si contiene solo dígitos
  static bool _containsOnlyDigits(String numeroDocumento) {
    return RegExp(r'^\d+$').hasMatch(numeroDocumento);
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
