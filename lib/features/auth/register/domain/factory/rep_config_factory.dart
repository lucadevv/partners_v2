// --- DOMINIO: FACTORY DEL REPRESENTANTE ---

import 'package:flutter/material.dart';
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
          keyboardType: TextInputType.number,
        );
      case DocumentType.ce:
        return RepDocFormConfig(
          label: "Nro. de documento",
          placeholder: "Ingrese CE del representante",
          maxLength: null,
          keyboardType: TextInputType.text,
        );
      default:
        return RepDocFormConfig(
          label: "Nro. de documento",
          placeholder: "Seleccione tipo primero",
          maxLength: null,
          keyboardType: TextInputType.text,
        );
    }
  }

  static RepDocFormConfig getNameConfig() {
    return RepDocFormConfig(
      label: "Nombres del registrante",
      placeholder: "Su nombre completo aparecerá aquí",
      maxLength: 100,
      keyboardType: TextInputType.text,
      enabled: false,
      readOnly: true,
    );
  }
}
