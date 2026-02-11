import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';

/// Campo de texto reutilizable. Error se muestra solo debajo (no en InputDecoration).
/// Según diseño Pencil: altura 77, borderRadius 10, borde primary (#0a2b7a).
class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final String? prefixText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool? enabled;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;

  /// Altura del campo (diseño: 77). Si null, no se fija altura.
  final double? fieldHeight;

  const CustomTextFormField({
    Key? key,
    this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.prefixText,
    this.prefixIcon,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.enabled,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.fieldHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: context.appTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface,
              fontSize: 12,
            ),
          ),
          8.spaceh,
        ],

        _buildField(context, theme, colorScheme),

        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText!,
              style: context.appTextTheme.bodySmall?.copyWith(
                color: colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildField(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    const double designHeight = 77;
    const double designBorderRadius = 10;
    final bool useDesignSize = fieldHeight != null;

    final contentPadding = useDesignSize
        ? const EdgeInsets.symmetric(horizontal: 26, vertical: 26)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    final borderRadius = useDesignSize ? designBorderRadius : 8.0;
    final borderColor = useDesignSize
        ? colorScheme.primary
        : colorScheme.outline;

    final child = TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      style: context.appTextTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: context.appTextTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        prefixText: prefixText,
        prefixStyle: context.appTextTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        helperText: helperText,
        filled: true,
        fillColor: colorScheme.onPrimary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: contentPadding,
        counterText: maxLength != null ? '' : null,
      ),
    );

    if (useDesignSize) {
      return SizedBox(height: fieldHeight ?? designHeight, child: child);
    }
    return child;
  }
}
