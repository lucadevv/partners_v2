import 'package:partners/core/utils/enums/enums.dart';

class DocFormConfig {
  final String label;
  final String placeholder;
  final int? maxLength;
  final KeyboardType keyboardType;

  DocFormConfig({
    required this.label,
    required this.placeholder,
    this.maxLength,
    required this.keyboardType,
  });
}
