import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/register/domain/entities/validators/doc_validator.dart';
import 'package:partners/features/auth/register/domain/forms/doc_form_config.dart';

class DocConfigFactory {
  static DocFormConfig getConfig(DocumentType? tipo) {
    DocValidatorStrategy validator = getValidatorStrategy(tipo);

    return DocFormConfig(
      label: "Nro. de documento",
      placeholder: tipo == DocumentType.dni
          ? "Ingrese DNI (8 dígitos)"
          : "Ingrese CE (Alfanumérico)",
      maxLength: validator.getMaxLength(),
      keyboardType: validator.getKeyboardType(),
    );
  }

  static DocValidatorStrategy getValidatorStrategy(DocumentType? tipo) {
    if (tipo == null) {
      throw Exception("Tipo de documento no seleccionado");
    }
    switch (tipo) {
      case DocumentType.dni:
        return DniStrategy();
      case DocumentType.ce:
        return CeStrategy();
    }
  }
}
