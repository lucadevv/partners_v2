import 'package:partners/features/auth/validation/domain/validators/validator.dart';

class PasswordValidatorStrategy implements Validator {
  @override
  bool validate(String value) {
    if (value.length < 8) return false;
    if (!value.contains(RegExp(r'[A-Z]'))) return false;
    if (!value.contains(RegExp(r'[a-z]'))) return false;
    if (!value.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  @override
  String getErrorMessage() =>
      "La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula y un número";

  @override
  int? getMaxLength() => null;
}
