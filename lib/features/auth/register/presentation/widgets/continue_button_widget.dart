import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';

class ContinueButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const ContinueButtonWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 36,
      right: 24,
      left: 24,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(
            context.appColor.secondary,
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          padding: WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          minimumSize: WidgetStatePropertyAll<Size>(
            Size(double.infinity, 56),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Icon(
              Icons.arrow_forward,
              color: const Color(0xFF051858),
              size: 20,
            ),
            Text(
              "Continuar",
              style: TextStyle(
                color: const Color(0xFF051858),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
