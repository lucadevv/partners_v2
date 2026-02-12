import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';

/// Campo de selección (dropdown tap) para categoría, subcategoría, horario, etc.
class CreateBranchSelectField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final VoidCallback onTap;
  final IconData? icon;
  final bool enabled;

  const CreateBranchSelectField({
    super.key,
    required this.label,
    required this.hint,
    this.value,
    required this.onTap,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: enabled
                ? context.appColor.onSurface
                : context.appColor.outline,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Figtree',
          ),
        ),
        8.spaceh,
        SizedBox(
          height: 77,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.appColor.primary, width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled ? onTap : null,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 26,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value ?? hint,
                            style: TextStyle(
                              color: value != null
                                  ? context.appColor.primary
                                  : enabled
                                      ? context.appColor.onSurfaceVariant
                                      : context.appColor.outline,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ),
                      ),
                      if (icon != null)
                        Icon(icon, color: context.appColor.primary, size: 24)
                      else
                        Icon(
                          Icons.arrow_drop_down,
                          color: enabled
                              ? context.appColor.primary
                              : context.appColor.outline,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
