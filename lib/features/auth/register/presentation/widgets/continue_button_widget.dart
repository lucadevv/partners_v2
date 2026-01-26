import 'package:flutter/material.dart';

class ContinueButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const ContinueButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 36,
      right: 24,
      left: 24,
      child: ElevatedButton(
        onPressed: onPressed,
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
      ),
    );
  }
}
