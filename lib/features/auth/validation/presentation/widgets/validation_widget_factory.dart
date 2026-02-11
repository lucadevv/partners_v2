import 'package:flutter/material.dart';
import 'package:partners/features/auth/validation/domain/entities/validation_entity.dart';
import 'package:partners/features/auth/validation/presentation/widgets/business_validation_widget.dart';
import 'package:partners/features/auth/validation/presentation/widgets/email_validation_widget.dart';
import 'package:partners/features/auth/validation/presentation/widgets/password_validation_widget.dart';
import 'package:partners/features/auth/validation/presentation/widgets/whatsapp_validation_widget.dart';

/// Factory para construir widgets de validación en Presentation Layer
/// Convierte widgetType (Domain) a Widget (Presentation)
class ValidationWidgetFactory {
  static Widget buildWidget(ItemValidation item) {
    switch (item.widgetType) {
      case 'email':
        return const EmailValidationWidget();
      case 'whatsapp':
        return const WhatsappValidationWidget();
      case 'password':
        return const PasswordValidationWidget();
      case 'business':
        return const BusinessValidationWidget();
      case 'identity':
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }

  static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'lock':
        return Icons.lock;
      case 'business':
        return Icons.business;
      case 'badge':
        return Icons.badge;
      default:
        return Icons.help_outline;
    }
  }
}
