import 'package:flutter/foundation.dart';

/// Keys para testing de widgets
class WidgetKeys {
  WidgetKeys._();

  // Register Screen
  static const registerRucSelectorKey = Key('register_ruc_selector');
  static const registerRuc10Key = Key('register_ruc10');
  static const registerRuc15Key = Key('register_ruc15');
  static const registerRuc20Key = Key('register_ruc20');
  static const registerDocumentFieldKey = Key('register_document_field');
  static const registerNamesFieldKey = Key('register_names_field');
  static const registerRazonSocialFieldKey = Key('register_razon_social_field');
  static const registerTipoDocRepFieldKey = Key('register_tipo_doc_rep_field');
  static const registerDocRepFieldKey = Key('register_doc_rep_field');
  static const registerContinueButtonKey = Key('register_continue_button');

  // Validation Screen
  static const validationEmailStepKey = Key('validation_email_step');
  static const validationWhatsappStepKey = Key('validation_whatsapp_step');
  static const validationPasswordStepKey = Key('validation_password_step');
  static const validationDocumentStepKey = Key('validation_document_step');

  // Validation Input Bottom Sheet
  static const validationInputFieldKey = Key('validation_input_field');
  static const validationInputContinueKey = Key('validation_input_continue');

  // OTP Bottom Sheet
  static const otpField1Key = Key('otp_field_1');
  static const otpField2Key = Key('otp_field_2');
  static const otpField3Key = Key('otp_field_3');
  static const otpField4Key = Key('otp_field_4');
  static const otpField5Key = Key('otp_field_5');
  static const otpContinueButtonKey = Key('otp_continue_button');

  // Document Scan Screen
  static const documentScanFrameKey = Key('document_scan_frame');
  static const documentScanCaptureButtonKey = Key('document_scan_capture_button');

  // Document Success Screen
  static const documentSuccessIconKey = Key('document_success_icon');
  static const documentSuccessContinueKey = Key('document_success_continue');

  // Business Validation Screen
  static const businessRucFieldKey = Key('business_ruc_field');
  static const businessRazonSocialFieldKey = Key('business_razon_social_field');
  static const businessContinueButtonKey = Key('business_continue_button');

  // Registration Success Screen
  static const registrationSuccessIconKey = Key('registration_success_icon');
  static const registrationSuccessButtonKey = Key('registration_success_button');
}
