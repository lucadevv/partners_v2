import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
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
        ? context.appColor.surface.withValues(alpha: 0.64)
        : context.appColor.surfaceContainerHighest;
    final textColor = isActive && !isReadOnly
        ? context.appColor.primary
        : context.appColor.onSurfaceVariant;

    return Padding(
      padding: EdgeInsets.only(bottom: errorText != null ? 4 : 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: isActive && !isReadOnly
              ? Border.all(color: context.appColor.primary, width: 1)
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
                style: TextStyle(
                  color: context.appColor.onSurfaceVariant.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Figtree',
                ),
              ),
              8.spaceh,
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
                    hintStyle: TextStyle(
                      color: context.appColor.onSurfaceVariant.withValues(alpha: 0.6),
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
                    style: TextStyle(
                      color: context.appColor.error,
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
