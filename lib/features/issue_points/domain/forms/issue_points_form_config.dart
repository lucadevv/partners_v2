import 'package:partners/features/auth/register/domain/forms/form_config.dart';

/// Configuración del formulario de emisión de puntos
/// Sigue el patrón de configuración del Domain (como RucFormConfig)
class IssuePointsFormConfig {
  final IssuePointsFieldDefinition voucherAmountField;
  final IssuePointsFieldDefinition pointsField;
  final IssuePointsFieldDefinition descriptionField;
  final IssuePointsFieldDefinition userNameField;

  const IssuePointsFormConfig({
    required this.voucherAmountField,
    required this.pointsField,
    required this.descriptionField,
    required this.userNameField,
  });
}

/// Definición de campo específica para issue_points
/// Extiende FieldDefinition siguiendo el patrón de NameFormConfig
class IssuePointsFieldDefinition extends FieldDefinition {
  IssuePointsFieldDefinition({
    required super.label,
    required super.placeholder,
    required super.keyboardType,
    super.maxLength,
    super.enabled,
    super.readOnly,
    super.obscureText,
  });
}
