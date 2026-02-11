import 'package:flutter/material.dart';
import 'package:partners/core/utils/utils.dart';
import 'package:partners/features/branches/domain/domain.dart';

/// Widget específico para campo de teléfono con prefijo +51
/// Sigue el patrón de BranchFieldWidget pero con prefijo
class BranchPhoneFieldWidget extends StatelessWidget {
  final BranchFieldDefinition field;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const BranchPhoneFieldWidget({
    super.key,
    required this.field,
    this.controller,
    this.errorText,
    this.onChanged,
    this.enabled = true,
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
          height: 77,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: enabled && !field.readOnly
                  ? Border.all(
                      color: const Color(0xFF0A2B7A),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 26),
                  child: Text(
                    '+51 ',
                    style: TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: KeyboardTypeConverter.toTextInputType(
                      field.keyboardType,
                    ),
                    maxLength: field.maxLength,
                    readOnly: field.readOnly,
                    enabled: enabled && field.enabled,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Figtree',
                    ),
                    decoration: InputDecoration(
                      hintText: field.placeholder,
                      hintStyle: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Figtree',
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 38,
                      ),
                      errorText: errorText,
                      counterText: '',
                    ),
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
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
    );
  }
}
