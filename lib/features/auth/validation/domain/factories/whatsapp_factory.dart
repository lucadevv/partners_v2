import 'package:flutter/material.dart';
import 'package:partners/features/auth/register/domain/forms/form_config.dart';
import 'package:partners/features/auth/validation/domain/fields/otp_field.dart';
import 'package:partners/features/auth/validation/domain/fields/phone_field.dart';
import 'package:partners/features/auth/validation/presentation/notifier/whatsapp_from_notifier.dart';

class WhatsappFactory {
  static List<FieldDefinition> getConfig(WhatsappSteps step) {
    switch (step) {
      case WhatsappSteps.phone:
        return [
          PhoneField(
            label: 'WhatsApp',
            placeholder: 'Ingrese número de WhatsApp',
            keyboardType: TextInputType.phone,
          ),
        ];
      case WhatsappSteps.verification:
        return [
          OtpField(
            label: '',
            placeholder: '-',
            keyboardType: TextInputType.text,
          ),
          OtpField(
            label: '',
            placeholder: '-',
            keyboardType: TextInputType.text,
          ),
          OtpField(
            label: '',
            placeholder: '-',
            keyboardType: TextInputType.text,
          ),
          OtpField(
            label: '',
            placeholder: '-',
            keyboardType: TextInputType.text,
          ),
          OtpField(
            label: '',
            placeholder: '-',
            keyboardType: TextInputType.text,
          ),
        ];
    }
  }
}
