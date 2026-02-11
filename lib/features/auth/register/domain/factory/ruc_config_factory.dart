// --- FACTORIES (Patrón CREACIONAL) ---

import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/register/domain/entities/validators/ruc_validator.dart';

import 'package:partners/features/auth/register/domain/forms/ruc_form_config.dart';

class RucConfigFactory {
  static RucFormConfig getConfig(RucType tipo) {
    switch (tipo) {
      case RucType.ruc10:
        return RucFormConfig(
          label: "RUC del negocio",
          placeholder: "Ingrese RUC (11 dígitos)",
          maxLength: 11,
          keyboardType: KeyboardType.number,
        );
      case RucType.ruc15:
        return RucFormConfig(
          label: "RUC del negocio",
          placeholder: "Ingrese RUC (11 dígitos)",
          maxLength: 11,
          keyboardType: KeyboardType.number,
        );
      case RucType.ruc20:
        return RucFormConfig(
          label: "RUC del negocio",
          placeholder: "Ingrese RUC (11 dígitos)",
          maxLength: 11,
          keyboardType: KeyboardType.number,
          showDocument: true,
          showTypeDocument: true,
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
