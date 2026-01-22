import 'package:flutter/material.dart';
import 'package:partners/features/auth/validation/presentation/notifier/validation_form_notifier.dart';

/// Widget para mostrar un step individual de validación
class ValidationStepWidget extends StatelessWidget {
  final String text;
  final StepStatus status;
  final VoidCallback? onTap;

  const ValidationStepWidget({
    super.key,
    required this.text,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == StepStatus.completed;
    final bool isActive = status == StepStatus.active;
    final bool isPending = status == StepStatus.pending;

    Color backgroundColor = Colors.transparent;
    Color textColor = const Color(0xFF051858);
    Color iconColor = const Color(0xFF051858);
    BorderSide? border;
    IconData icon = Icons.arrow_forward;

    if (isCompleted) {
      backgroundColor = const Color(0xFF051858);
      textColor = Colors.white;
      iconColor = Colors.white;
      icon = Icons.check;
    } else if (isActive) {
      backgroundColor = const Color(0xFF66CFFF);
      textColor = const Color(0xFF051858);
      iconColor = const Color(0xFF051858);
      icon = Icons.arrow_forward;
    } else if (isPending) {
      backgroundColor = Colors.transparent;
      textColor = const Color(0xFF051858);
      iconColor = const Color(0xFF051858);
      border = BorderSide(color: const Color(0xFF051858), width: 1.5);
      icon = Icons.arrow_forward;
    }

    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
          border: border != null ? Border.all(color: border.color, width: border.width) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          spacing: 12,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
