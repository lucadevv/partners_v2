import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/register/domain/entities/validators/ruc_validator.dart';

import 'package:partners/features/auth/register/domain/forms/name_form_config.dart';

class NameConfigFactory {
  static NameFormConfig getConfig(RucType tipo) {
    switch (tipo) {
      case RucType.ruc10:
        return NameFormConfig(
          label: "Nombre del registrante",
          placeholder: "Su nombre completo, aparece aquí",
          keyboardType: KeyboardType.name,
          enabled: false,
          readOnly: true,
        );
      case RucType.ruc15:
        return NameFormConfig(
          label: "Nombre del registrante",
          placeholder: "Su nombre completo, aparece aquí",
          keyboardType: KeyboardType.name,
          enabled: false,
          readOnly: true,
        );
      case RucType.ruc20:
        return NameFormConfig(
          label: "Nombre de la empresa",
          placeholder: "Su razón social aparece aquí",
          keyboardType: KeyboardType.name,
          enabled: false,
          readOnly: true,
        );
    }
  }

  static RucStrategy getValidatorStrategy(RucType tipo) {
    switch (tipo) {
      case RucType.ruc10:
        return Ruc10Strategy();
      case RucType.ruc15:
        return Ruc15Strategy();
      case RucType.ruc20:
        return Ruc20Strategy();
    }
  }
}
