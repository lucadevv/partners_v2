// --- ESTRATEGIAS DE VALIDACIÓN (Pilar: POLIMORFISMO) ---

import 'package:flutter/material.dart';

abstract class DocValidatorStrategy {
  bool validate(String value);
  String getErrorMessage();
  int? getMaxLength();
  TextInputType getKeyboardType();
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
  TextInputType getKeyboardType() => TextInputType.number;
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
  TextInputType getKeyboardType() => TextInputType.text;
}
