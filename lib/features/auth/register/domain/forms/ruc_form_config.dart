import 'package:partners/features/auth/register/domain/forms/form_config.dart';

class RucFormConfig extends FieldDefinition {
  final bool showDocument;
  final bool showTypeDocument;
  RucFormConfig({
    required super.label,
    required super.placeholder,
    required super.keyboardType,
    super.maxLength,
    this.showDocument = false,
    this.showTypeDocument = false,
  });
}
