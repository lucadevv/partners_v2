import 'package:partners/core/utils/enums/enums.dart';

abstract class FieldDefinition {
  final String label;
  final String placeholder;
  final int? maxLength;
  final KeyboardType keyboardType;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  FieldDefinition({
    required this.label,
    required this.placeholder,
    required this.keyboardType,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
  });
}
