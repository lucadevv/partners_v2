import 'package:flutter/material.dart';

class DocFormConfig {
  final String label;
  final String placeholder;
  final int? maxLength;
  final TextInputType keyboardType;

  DocFormConfig({
    required this.label,
    required this.placeholder,
    this.maxLength,
    required this.keyboardType,
  });
}
