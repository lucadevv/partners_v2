import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';
import 'package:partners/core/theme/app_colors_ligth.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String? label;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final void Function()? onTap;
  final TextInputAction? textInputAction;
  final bool? isFocused;

  const CustomTextFieldWidget({
    super.key,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.enabled = true,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.maxLines = 1,
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
    this.isFocused,
  });

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  Color _getBorderColor(BuildContext context) {
    if (!widget.enabled) {
      return AppColorsLigth.surfaceContainerHighest;
    }
    if (widget.isFocused == true || _isFocused) {
      return AppColorsLigth.primary;
    }
    return AppColorsLigth.onPrimary; // Borde blanco por defecto
  }

  bool _shouldShowBorder() {
    if (!widget.enabled) {
      return false;
    }
    return widget.isFocused == true || _isFocused;
  }

  Color _getLabelColor(BuildContext context) {
    if (!widget.enabled) {
      return AppColorsLigth.onSurfaceVariant.withValues(alpha: 0.5);
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.enabled
            ? context.appColor.onPrimary
            : AppColorsLigth.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getBorderColor(context),
          width: _shouldShowBorder() ? 1 : 0,
        ),
      ),
      child: SizedBox(
        height: widget.maxLines != null && widget.maxLines! > 1 ? null : 78,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.label != null) ...[
                Text(
                  widget.label!,
                  style: TextStyle(
                    color: _getLabelColor(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                1.spaceh,
              ],
              TextFormField(
                controller: widget.controller,
                validator: widget.validator,
                enabled: widget.enabled,
                obscureText: _obscureText,
                keyboardType: widget.keyboardType,
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onSubmitted,
                focusNode: _focusNode,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                readOnly: widget.readOnly,
                onTap: widget.onTap,
                textInputAction: widget.textInputAction,

                style: TextStyle(
                  color: widget.enabled
                      ? AppColorsLigth.onSurface
                      : AppColorsLigth.onSurface.withValues(alpha: 0.38),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  filled: true,
                  fillColor: widget.enabled
                      ? context.appColor.onPrimary
                      : context.appColor.surfaceContainerHighest,
                  hintStyle: TextStyle(
                    color: widget.enabled
                        ? AppColorsLigth.primary
                        : AppColorsLigth.onSurfaceVariant,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIconColor: context.appColor.primary,
                  suffixIconColor: context.appColor.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.enabled
                          ? AppColorsLigth.onPrimary
                          : context.appColor.surfaceContainerHighest,
                      width: 0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.enabled
                          ? AppColorsLigth.onPrimary
                          : context.appColor.surfaceContainerHighest,
                      width: 0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.enabled
                          ? AppColorsLigth.onPrimary
                          : context.appColor.surfaceContainerHighest,
                      width: 0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.enabled
                          ? AppColorsLigth.onPrimary
                          : context.appColor.surfaceContainerHighest,
                      width: 0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColorsLigth.error,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColorsLigth.error,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  suffixIcon: widget.obscureText
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: widget.enabled
                                ? AppColorsLigth.primary
                                : AppColorsLigth.onSurfaceVariant.withValues(
                                    alpha: 0.38,
                                  ),
                          ),
                          onPressed: widget.enabled
                              ? () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                }
                              : null,
                        )
                      : widget.suffixIcon,
                  prefixIcon: widget.prefixIcon,
                  counterText: '',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
