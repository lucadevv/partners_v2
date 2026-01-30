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
