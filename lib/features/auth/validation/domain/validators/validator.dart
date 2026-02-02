abstract class Validator {
  bool validate(String value);
  String getErrorMessage();
  int? getMaxLength();
}

class EmailValidatorStrategy implements Validator {
  @override
  bool validate(String value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(value);
  }

  @override
  String getErrorMessage() => "El correo electrónico no es válido";

  @override
  int? getMaxLength() => 254;
}

class PhoneValidatorStrategy implements Validator {
  @override
  bool validate(String value) {
    // Validar que sea un número de teléfono peruano (9 dígitos)
    final phoneRegex = RegExp(r'^[0-9]{9}$');
    return phoneRegex.hasMatch(value);
  }

  @override
  String getErrorMessage() => "El número de teléfono no es válido";

  @override
  int? getMaxLength() => 9;
}
