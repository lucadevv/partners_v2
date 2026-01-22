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
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value != null && value!.isNotEmpty;
    final Color backgroundColor = enabled ? Colors.white : const Color(0xFFF3F4F6);
    final Color labelColor = enabled
        ? const Color(0xFF6B7280)
        : const Color(0xFF9CA3AF);
    final Color textColor = hasValue
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
            if (controller != null && enabled)
              TextField(
                controller: controller,
                keyboardType: keyboardType,
                maxLength: maxLength,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF051858),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: placeholder,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF9CA3AF),
                  ),
                  suffixIcon: suffixIcon,
                  counterText: '', // Ocultar contador
                ),
                onTap: onTap,
                readOnly: onTap != null,
              )
            else
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hasValue ? value! : (placeholder ?? ''),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (suffixIcon != null) suffixIcon!,
                ],
              ),
          ],
        ),
      ),
    );
  }
}
