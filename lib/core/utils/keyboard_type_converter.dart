import 'package:flutter/material.dart';
import 'package:partners/core/utils/enums/enums.dart';

/// Helper para convertir KeyboardType (Domain) a TextInputType (Presentation)
/// Sigue el principio de separación de capas
class KeyboardTypeConverter {
  static TextInputType toTextInputType(KeyboardType keyboardType) {
    switch (keyboardType) {
      case KeyboardType.text:
        return TextInputType.text;
      case KeyboardType.number:
        return TextInputType.number;
      case KeyboardType.phone:
        return TextInputType.phone;
      case KeyboardType.email:
        return TextInputType.emailAddress;
      case KeyboardType.visiblePassword:
        return TextInputType.visiblePassword;
      case KeyboardType.name:
        return TextInputType.name;
    }
  }
}
