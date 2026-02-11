/// Estrategia de validación para campos del formulario de sucursal
/// Sigue Strategy Pattern (como RucStrategy, DocValidatorStrategy)
abstract class BranchValidatorStrategy {
  /// Valida el valor del campo
  bool validate(String value);

  /// Retorna mensaje de error si la validación falla
  String getErrorMessage();
}

/// Validador para nombre de sucursal
class BranchNameValidator implements BranchValidatorStrategy {
  @override
  bool validate(String value) {
    if (value.isEmpty) return false;
    return value.length >= 3 && value.length <= 100;
  }

  @override
  String getErrorMessage() {
    return 'El nombre debe tener entre 3 y 100 caracteres';
  }
}

/// Validador para teléfono
class BranchPhoneValidator implements BranchValidatorStrategy {
  @override
  bool validate(String value) {
    if (value.isEmpty) return false;
    final phoneRegex = RegExp(r'^[0-9]{9}$');
    return phoneRegex.hasMatch(value);
  }

  @override
  String getErrorMessage() {
    return 'El teléfono debe tener 9 dígitos';
  }
}

/// Validador para dirección
class BranchAddressValidator implements BranchValidatorStrategy {
  @override
  bool validate(String value) {
    if (value.isEmpty) return false;
    return value.length >= 10 && value.length <= 200;
  }

  @override
  String getErrorMessage() {
    return 'La dirección debe tener entre 10 y 200 caracteres';
  }
}
