import 'package:flutter/material.dart';

import 'package:partners/core/utils/validations/phone_validator.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_field_widget.dart';

/// Bottom Sheet genérico para capturar input de validación (email, whatsapp, password)
class ValidationInputBottomSheet extends StatefulWidget {
  final String title;
  final String label;
  final String placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Function(String) onContinue;
  final bool isEmail;
  final bool isPhone;

  const ValidationInputBottomSheet({
    super.key,
    required this.title,
    required this.label,
    required this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    required this.onContinue,
    this.isEmail = false,
    this.isPhone = false,
  });

  static Future<String?> show({
    required BuildContext context,
    required String title,
    required String label,
    required String placeholder,
    TextInputType? keyboardType,
    bool obscureText = false,
    required Widget backgroundWidget,
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => ValidationInputBottomSheet(
        title: title,
        label: label,
        placeholder: placeholder,
        keyboardType: keyboardType,
        obscureText: obscureText,
        isEmail: isEmail,
        isPhone: isPhone,
        onContinue: (value) {
          Navigator.of(context).pop(value);
        },
      ),
    );
  }

  @override
  State<ValidationInputBottomSheet> createState() =>
      _ValidationInputBottomSheetState();
}

class _ValidationInputBottomSheetState
    extends State<ValidationInputBottomSheet> {
  late TextEditingController _controller;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final value = _controller.text.trim();

    // Validar que no esté vacío
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete el campo')),
      );
      return;
    }

    // // Validar email si es campo de email
    // if (widget.isEmail && !EmailValidator.isValidEmail(value)) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Por favor ingrese un correo electrónico válido'),
    //     ),
    //   );
    //   return;
    // }

    // Validar celular peruano si es campo de teléfono
    if (widget.isPhone && !PhoneValidator.isValidPeruvianPhone(value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor ingrese un número de celular peruano válido (9 dígitos, debe empezar con 9)',
          ),
        ),
      );
      return;
    }

    // Si es teléfono, limpiar el número antes de retornarlo
    final finalValue = widget.isPhone
        ? PhoneValidator.cleanPhoneNumber(value)
        : value;
    widget.onContinue(finalValue);
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
          spacing: 20,
          children: [
            // Header
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xFF051858),
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.title,
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

            // Campo de input
            if (widget.obscureText)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0A2B7A), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            obscureText: !_isPasswordVisible,
                            keyboardType: widget.keyboardType,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF051858),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              hintText: widget.placeholder,
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF9CA3AF),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              RegisterFieldWidget(
                label: widget.label,
                placeholder: widget.placeholder,
                controller: _controller,
                keyboardType: widget.keyboardType,
              ),

            // Botón continuar
            ElevatedButton(
              onPressed: _handleContinue,
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
