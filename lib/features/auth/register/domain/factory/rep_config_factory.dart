// --- DOMINIO: FACTORY DEL REPRESENTANTE ---

import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/register/domain/forms/rep_doc_form_config.dart';

class RepConfigFactory {
  static RepDocFormConfig getDocConfig(DocumentType? tipo) {
    switch (tipo) {
      case DocumentType.dni:
        return RepDocFormConfig(
          label: "Nro. de documento",
          placeholder: "Ingrese DNI del representante",
          maxLength: 8,
          keyboardType: KeyboardType.number,
        );
      case DocumentType.ce:
        return RepDocFormConfig(
          label: "Nro. de documento",
          placeholder: "Ingrese CE del representante",
          maxLength: null,
          keyboardType: KeyboardType.text,
        );
      default:
        return RepDocFormConfig(
          label: "Nro. de documento",
          placeholder: "Seleccione tipo primero",
          maxLength: null,
          keyboardType: KeyboardType.text,
        );
    }
  }

  static RepDocFormConfig getNameConfig() {
    return RepDocFormConfig(
      label: "Nombres del registrante",
      placeholder: "Su nombre completo aparecerá aquí",
      maxLength: 100,
      keyboardType: KeyboardType.text,
      enabled: false,
      readOnly: true,
    );
  }
}
