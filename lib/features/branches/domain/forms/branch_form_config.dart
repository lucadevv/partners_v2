import 'package:partners/features/auth/register/domain/forms/form_config.dart';

/// Configuración del formulario de creación de sucursal
/// Sigue el patrón de configuración del Domain (como RucFormConfig)
class BranchFormConfig {
  final BranchFieldDefinition nameField;
  final BranchFieldDefinition phoneField;
  final BranchFieldDefinition addressField;

  const BranchFormConfig({
    required this.nameField,
    required this.phoneField,
    required this.addressField,
  });
}

/// Definición de campo específica para branches
/// Extiende FieldDefinition siguiendo el patrón de NameFormConfig
class BranchFieldDefinition extends FieldDefinition {
  BranchFieldDefinition({
    required super.label,
    required super.placeholder,
    required super.keyboardType,
    super.maxLength,
    super.enabled,
    super.readOnly,
    super.obscureText,
  });
}
