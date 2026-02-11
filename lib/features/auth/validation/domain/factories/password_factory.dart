import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/register/domain/forms/form_config.dart';
import 'package:partners/features/auth/validation/domain/fields/password_field.dart';
import 'package:partners/features/auth/validation/presentation/notifier/password_from_notifier.dart';

class PasswordFactory {
  static List<FieldDefinition> getConfig(PasswordSteps step) {
    switch (step) {
      case PasswordSteps.createPassword:
        return [
          PasswordField(
            label: 'Contraseña',
            placeholder: 'Ingrese su contraseña',
            keyboardType: KeyboardType.visiblePassword,
          ),
        ];
      case PasswordSteps.confirmPassword:
        return [
          PasswordField(
            label: 'Contraseña',
            placeholder: 'Ingrese su contraseña',
            keyboardType: KeyboardType.visiblePassword,
          ),
          PasswordField(
            label: 'Confirmar Contraseña',
            placeholder: 'Confirme su contraseña',
            keyboardType: KeyboardType.visiblePassword,
          ),
        ];
    }
  }
}
