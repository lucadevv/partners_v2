import 'package:flutter/material.dart';
import 'package:partners/core/utils/utils.dart';
import 'package:partners/features/branches/domain/domain.dart';

/// Widget reutilizable para campos del formulario de sucursal
/// Sigue el patrón de RegisterFieldWidget pero específico para branches
/// Aplica POO: Single Responsibility Principle (SRP)
class BranchFieldWidget extends StatelessWidget {
  final BranchFieldDefinition field;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final double? height;

  const BranchFieldWidget({
    super.key,
    required this.field,
    this.controller,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = enabled ? Colors.white : const Color(0xFFF3F4F6);
    final labelColor = enabled ? Colors.black : const Color(0xFFC6C6C6);
    final textColor = enabled ? const Color(0xFF051858) : const Color(0xFF9CA3AF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Figtree',
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: height ?? 77,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: enabled
                  ? Border.all(
                      color: const Color(0xFF0A2B7A),
                      width: 1,
                    )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Figtree',
                ),
                keyboardType: KeyboardTypeConverter.toTextInputType(
                  field.keyboardType,
                ),
                maxLength: field.maxLength,
                readOnly: field.readOnly,
                enabled: enabled && field.enabled,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: backgroundColor,
                  hintText: field.placeholder,
                  hintStyle: TextStyle(
                    color: const Color(0xFF051858),
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 26,
                  ),
                  counterText: '',
                ),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
