/// Estrategia de validación para campos del formulario de emisión de puntos
/// Sigue Strategy Pattern (como RucStrategy, DocValidatorStrategy)
abstract class IssuePointsValidatorStrategy {
  /// Valida el valor del campo
  bool validate(String value);

  /// Retorna mensaje de error si la validación falla
  String getErrorMessage();

  /// Retorna el tipo de teclado apropiado
  // Ya está en KeyboardType enum, no necesitamos retornarlo aquí
}

/// Validador para monto del voucher
class VoucherAmountValidator implements IssuePointsValidatorStrategy {
  @override
  bool validate(String value) {
    if (value.isEmpty) return false;
    final amount = double.tryParse(value);
    if (amount == null) return false;
    return amount > 0;
  }

  @override
  String getErrorMessage() {
    return 'El monto debe ser mayor a 0';
  }
}

/// Validador para puntos a emitir
class PointsValidator implements IssuePointsValidatorStrategy {
  @override
  bool validate(String value) {
    if (value.isEmpty) return false;
    final points = int.tryParse(value);
    if (points == null) return false;
    return points > 0;
  }

  @override
  String getErrorMessage() {
    return 'Los puntos deben ser mayor a 0';
  }
}

/// Validador para descripción
class DescriptionValidator implements IssuePointsValidatorStrategy {
  @override
  bool validate(String value) {
    return value.isNotEmpty && value.length >= 3;
  }

  @override
  String getErrorMessage() {
    return 'La descripción debe tener al menos 3 caracteres';
  }
}
