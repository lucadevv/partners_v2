import 'package:flutter/material.dart';
import 'package:partners/core/utils/utils.dart';
import 'package:partners/features/issue_points/domain/domain.dart';

/// Widget reutilizable para campos del formulario de emisión de puntos
/// Sigue el patrón de RegisterFieldWidget pero específico para issue_points
/// Aplica POO: Single Responsibility Principle (SRP)
class IssuePointsFieldWidget extends StatelessWidget {
  final IssuePointsFieldDefinition field;
  final TextEditingController? controller;
  final String? value;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool isActive;
  final TextAlign textAlign;

  const IssuePointsFieldWidget({
    super.key,
    required this.field,
    this.controller,
    this.value,
    this.errorText,
    this.onChanged,
    this.isActive = true,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final isReadOnly = field.readOnly || value != null;
    final backgroundColor = isActive && !isReadOnly
        ? Colors.white.withValues(alpha: 0.64)
        : const Color(0xFFE5E7EB);
    final textColor = isActive && !isReadOnly
        ? const Color(0xFF00114A)
        : const Color(0xFF696969);

    return Padding(
      padding: EdgeInsets.only(bottom: errorText != null ? 4 : 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: isActive && !isReadOnly
              ? Border.all(color: const Color(0xFF0A2B7A), width: 1)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
                textAlign: textAlign,
                style: const TextStyle(
                  color: Color(0xFFC6C6C6),
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Figtree',
                ),
              ),
              const SizedBox(height: 8),
              if (isReadOnly && value != null)
                Text(
                  value!,
                  textAlign: textAlign,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                  ),
                )
              else
                TextField(
                  controller: controller,
                  style: TextStyle(
                    color: textColor,
                    fontSize: textAlign == TextAlign.center ? 23 : 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                  ),
                  textAlign: textAlign,
                  keyboardType: KeyboardTypeConverter.toTextInputType(
                    field.keyboardType,
                  ),
                  maxLength: field.maxLength,
                  maxLines: field.label.toLowerCase().contains('descripción') ? 3 : 1,
                  readOnly: field.readOnly,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: field.placeholder,
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 18,
                    ),
                    counterText: '',
                  ),
                  onChanged: onChanged,
                ),
              if (errorText != null)
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
          ),
        ),
      ),
    );
  }
}
