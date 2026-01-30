import 'package:flutter/material.dart';

/// Widget de campo de texto para registro
class RegisterFieldWidget extends StatelessWidget {
  final String label;
  final String? placeholder;
  final String? value;
  final bool enabled;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final int? maxLength;
  final String? errorText;
  final Function(String)? onChanged;
  final bool? readOnly;
  final Widget? prefix;
  final Widget? suffix;

  const RegisterFieldWidget({
    super.key,
    required this.label,
    this.placeholder,
    this.value,
    this.enabled = true,
    this.onTap,
    this.controller,
    this.keyboardType,
    this.suffixIcon,
    this.maxLength,
    this.errorText,
    this.onChanged,
    this.readOnly = false,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = enabled
        ? Colors.white
        : const Color(0xFFF3F4F6);
    final Color labelColor = enabled
        ? const Color(0xFF6B7280)
        : const Color(0xFF9CA3AF);
    final Color textColor = enabled
        ? const Color(0xFF051858)
        : const Color(0xFF9CA3AF);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: enabled
              ? Border.all(color: const Color(0xFF0A2B7A), width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: labelColor,
              ),
            ),
            // if (controller != null && enabled)
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLength,

              onChanged: (value) => onChanged?.call(value),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: textColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: backgroundColor,
                prefix: prefix != null
                    ? SizedBox(height: 16, width: 16, child: prefix)
                    : null,
                suffix: suffix != null
                    ? SizedBox(height: 16, width: 16, child: suffix)
                    : null,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: placeholder,
                errorText: errorText,
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF9CA3AF),
                ),
                suffixIcon: suffixIcon,
                counterText: '', // Ocultar contador
              ),
              onTap: onTap,
              readOnly: readOnly!,
            ),
          ],
        ),
      ),
    );
  }
}
