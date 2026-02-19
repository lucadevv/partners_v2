import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';

class ContinueButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const ContinueButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColor;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Icon(Icons.arrow_forward, size: 20),
          Text(
            "Continuar",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
