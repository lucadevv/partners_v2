// --- ESTRATEGIAS DE VALIDACIÓN (Pilar: POLIMORFISMO) ---

import 'package:partners/core/utils/enums/enums.dart';

abstract class DocValidatorStrategy {
  bool validate(String value);
  String getErrorMessage();
  int? getMaxLength();
  KeyboardType getKeyboardType();
}

// Implementación DNI
class DniStrategy implements DocValidatorStrategy {
  @override
  bool validate(String value) => RegExp(r'^[0-9]{8}$').hasMatch(value);

  @override
  String getErrorMessage() => "El DNI debe tener 8 dígitos numéricos";

  @override
  int? getMaxLength() => 8;

  @override
  KeyboardType getKeyboardType() => KeyboardType.number;
}

// Implementación Carnet Extranjería
class CeStrategy implements DocValidatorStrategy {
  @override
  bool validate(String value) =>
      RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value) && value.isNotEmpty;

  @override
  String getErrorMessage() => "El CE no debe tener caracteres especiales";

  @override
  int? getMaxLength() => 9; // Ejemplo

  @override
  KeyboardType getKeyboardType() => KeyboardType.text;
}
