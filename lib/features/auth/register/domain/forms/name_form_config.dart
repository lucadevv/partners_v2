import 'package:partners/features/auth/register/domain/forms/form_config.dart';

class NameFormConfig extends FieldDefinition {
  NameFormConfig({
    required super.label,
    required super.placeholder,
    required super.keyboardType,
    super.enabled,
    super.readOnly,
  });
}
