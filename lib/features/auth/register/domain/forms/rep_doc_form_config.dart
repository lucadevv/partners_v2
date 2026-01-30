import 'package:partners/features/auth/register/domain/forms/form_config.dart';

class RepDocFormConfig extends FieldDefinition {
  RepDocFormConfig({
    required super.label,
    required super.placeholder,
    required super.maxLength,
    required super.keyboardType,
    super.enabled = true,
    super.readOnly = false,
  });
}
