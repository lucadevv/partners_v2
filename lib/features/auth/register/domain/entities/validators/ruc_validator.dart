import 'package:partners/core/utils/enums/enums.dart';

// --- ESTRATEGIAS DE VALIDACIÓN PARA RUC (Pilar: POLIMORFISMO) ---

abstract class RucStrategy {
  bool validate(String value);
  String getErrorMessage();
  int? getMaxLength();
  KeyboardType getKeyboardType();
  RucType getRuc();
}

// Implementación RUC Persona Natural (10)
class Ruc10Strategy implements RucStrategy {
  @override
  bool validate(String ruc) {
    return ruc.length == 11 && ruc.startsWith('10');
  }

  @override
  String getErrorMessage() => "El RUC debe tener 11 dígitos y comenzar con 10";

  @override
  int? getMaxLength() => 11;

  @override
  KeyboardType getKeyboardType() => KeyboardType.number;

  @override
  RucType getRuc() => RucType.ruc10;
}

// Implementación RUC Persona Jurídica (15)
class Ruc15Strategy implements RucStrategy {
  @override
  bool validate(String ruc) {
    return ruc.length == 11 && ruc.startsWith('15');
  }

  @override
  String getErrorMessage() => "El RUC debe tener 11 dígitos y comenzar con 15";

  @override
  int? getMaxLength() => 11;

  @override
  KeyboardType getKeyboardType() => KeyboardType.number;

  @override
  RucType getRuc() => RucType.ruc15;
}

// Implementación RUC Persona Jurídica (20)
class Ruc20Strategy implements RucStrategy {
  @override
  bool validate(String ruc) {
    return ruc.length == 11 && ruc.startsWith('20');
  }

  @override
  String getErrorMessage() => "El RUC debe tener 11 dígitos y comenzar con 20";

  @override
  int? getMaxLength() => 11;

  @override
  KeyboardType getKeyboardType() => KeyboardType.number;

  @override
  RucType getRuc() => RucType.ruc20;
}

// Implementación RUC General (para cuando no se especifica tipo)
class RucGeneralStrategy implements RucStrategy {
  @override
  bool validate(String ruc) {
    return ruc.length == 11 &&
        (ruc.startsWith('10') || ruc.startsWith('15') || ruc.startsWith('20'));
  }

  @override
  String getErrorMessage() =>
      "El RUC debe tener 11 dígitos y comenzar con 10, 15 o 20";

  @override
  int? getMaxLength() => 11;

  @override
  KeyboardType getKeyboardType() => KeyboardType.number;

  @override
  RucType getRuc() => RucType.ruc10;
}
