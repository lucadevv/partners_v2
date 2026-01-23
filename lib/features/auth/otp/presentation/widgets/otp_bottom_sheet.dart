import 'package:flutter/material.dart';
import 'package:partners/features/auth/otp/presentation/widgets/otp_field_widget.dart';

/// Bottom Sheet para validación OTP
class OtpBottomSheet extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final Function(String) onCodeCompleted;

  const OtpBottomSheet({
    super.key,
    required this.title,
    required this.onBack,
    required this.onCodeCompleted,
  });

  static Future<String?> show({
    required BuildContext context,
    required String title,
    required Widget backgroundWidget,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => OtpBottomSheet(
        title: title,
        onBack: () => Navigator.of(context).pop(),
        onCodeCompleted: (code) {
          Navigator.of(context).pop(code);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: keyboardHeight + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: onBack,
                      child: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF051858),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF051858),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),

                // Instrucción
                Text(
                  'Ingresa el código de verificación',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6B7280),
                  ),
                ),

                // Campos OTP
                OtpFieldsRowWidget(length: 5, onCompleted: onCodeCompleted),

                // Botón continuar
                ElevatedButton(
                  onPressed: () {
                    // El onCodeCompleted ya se llama cuando se completa el código
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66CFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    minimumSize: Size(double.infinity, 56),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: const Color(0xFF051858),
                        size: 20,
                      ),
                      Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF051858),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
