import 'package:flutter/material.dart';
import 'package:partners/features/auth/validation/presentation/notifier/validation_form_notifier.dart';

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
    final isCompleted = status == StepStatus.completed;
    final isActive = status == StepStatus.active;
    final isPending = status == StepStatus.pending;

    final colors = _getColors(isCompleted, isActive, isPending);
    final icon = _getIcon(isCompleted, isActive);

    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(50),
          border: colors.border != null
              ? Border.all(color: colors.border!.color, width: colors.border!.width)
              : null,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: colors.iconColor, size: 31),
              const SizedBox(width: 25),
            ],
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: colors.textColor,
                  fontFamily: 'Figtree',
                  height: 1.22,
                ),
                textAlign: isCompleted || isActive ? TextAlign.left : TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StepColors _getColors(bool isCompleted, bool isActive, bool isPending) {
    if (isCompleted) {
      return _StepColors(
        backgroundColor: const Color(0xFF051858),
        textColor: Colors.white,
        iconColor: Colors.white,
      );
    } else if (isActive) {
      return _StepColors(
        backgroundColor: const Color(0xFF66CFFF),
        textColor: const Color(0xFF051858),
        iconColor: const Color(0xFF051858),
      );
    } else {
      return _StepColors(
        backgroundColor: Colors.transparent,
        textColor: const Color(0xFF051858),
        iconColor: const Color(0xFF051858),
        border: const BorderSide(color: Color(0xFF051858), width: 1.5),
      );
    }
  }

  IconData? _getIcon(bool isCompleted, bool isActive) {
    if (isCompleted) return Icons.check_circle_outline;
    if (isActive) return Icons.arrow_forward;
    return null;
  }
}

class _StepColors {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final BorderSide? border;

  _StepColors({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    this.border,
  });
}
