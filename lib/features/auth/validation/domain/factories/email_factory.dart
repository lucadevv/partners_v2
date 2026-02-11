import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/register/domain/forms/form_config.dart';
import 'package:partners/features/auth/validation/domain/fields/email_field.dart';
import 'package:partners/features/auth/validation/domain/fields/otp_field.dart';
import 'package:partners/features/auth/validation/presentation/notifier/email_from_notifier.dart';

class EmailFactory {
  static List<FieldDefinition> getConfig(EmailSteps step) {
    switch (step) {
      case EmailSteps.email:
        return [
          EmailField(
            label: 'Email',
            placeholder: 'Ingrese correo electrónico',
            keyboardType: KeyboardType.email,
          ),
        ];
      case EmailSteps.verification:
        return [
          OtpField(
            label: '',
            placeholder: '-',
            keyboardType: KeyboardType.text,
          ),
          OtpField(
            label: '',
            placeholder: '-',
            keyboardType: KeyboardType.text,
          ),
          OtpField(
            label: '',
            placeholder: '-',
            keyboardType: KeyboardType.text,
          ),
          OtpField(
            label: '',
            placeholder: '-',
            keyboardType: KeyboardType.text,
          ),
          OtpField(
            label: '',
            placeholder: '-',
            keyboardType: KeyboardType.text,
          ),
        ];
    }
  }
}
