import 'package:flutter/material.dart';
import 'package:partners/features/auth/business_validation/presentation/notifier/business_validation_form_notifier.dart';

/// Widget para mostrar un step individual de validación de negocio
/// Usa los mismos colores que ValidationStepWidget pero mantiene los iconos originales
class BusinessValidationStepWidget extends StatelessWidget {
  final String text;
  final BusinessStepStatus status;
  final VoidCallback? onTap;

  const BusinessValidationStepWidget({
    super.key,
    required this.text,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == BusinessStepStatus.completed;
    final bool isActive = status == BusinessStepStatus.active;
    final bool isPending = status == BusinessStepStatus.pending;

    Color backgroundColor = Colors.transparent;
    Color textColor = const Color(0xFF051858);
    Color iconColor = const Color(0xFF051858);
    BorderSide? border;
    IconData? icon;

    if (isCompleted) {
      backgroundColor = const Color(0xFF051858);
      textColor = Colors.white;
      iconColor = Colors.white;
      icon = Icons.check_circle_outline;
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
      // Para pending, no mostrar icono o mostrar arrow_forward según diseño original
      icon = null;
    }

    return GestureDetector(
      onTap: (isActive || isCompleted) ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
          border: border != null ? Border.all(color: border.color, width: border.width) : null,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 31),
              const SizedBox(width: 25),
            ],
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: textColor,
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
}
