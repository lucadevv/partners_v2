/// Validador para números de teléfono peruanos
///
/// Implementa validaciones específicas para celulares peruanos:
/// - Debe tener 9 dígitos
/// - Puede empezar con 9 (formato estándar peruano)
/// - Solo puede contener números
/// - No puede estar vacío
class PhoneValidator {
  PhoneValidator._();

  /// Longitud válida para celular peruano
  static const int _phoneLength = 9;

  /// Valida si un número de celular es válido para Perú
  ///
  /// [phoneNumber] El número de celular a validar
  ///
  /// Retorna `true` si es válido, `false` en caso contrario
  static bool isValidPeruvianPhone(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return false;
    }

    // Remover espacios y caracteres especiales
    final cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Validar que tenga 9 dígitos
    if (cleaned.length != _phoneLength) {
      return false;
    }

    // Validar que contenga solo dígitos
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return false;
    }

    // Validar que empiece con 9 (formato estándar peruano)
    if (!cleaned.startsWith('9')) {
      return false;
    }

    return true;
  }

  /// Valida si un número de teléfono no está vacío
  ///
  /// [phoneNumber] El número de teléfono a validar
  ///
  /// Retorna `true` si no está vacío
  static bool isNotEmpty(String? phoneNumber) {
    return phoneNumber != null && phoneNumber.trim().isNotEmpty;
  }

  /// Limpia el número de teléfono removiendo espacios y caracteres especiales
  ///
  /// [phoneNumber] El número de teléfono a limpiar
  ///
  /// Retorna el número limpio
  static String cleanPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }
}
