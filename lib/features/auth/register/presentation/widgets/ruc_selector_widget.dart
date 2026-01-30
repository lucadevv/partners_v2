import 'package:flutter/material.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/register/presentation/notifier/register_form_notifier.dart';

class RucSelectorWidget extends StatelessWidget {
  final RegisterFormNotifier formNotifier;
  final RucType type;
  final String label;

  const RucSelectorWidget({
    super.key,
    required this.formNotifier,
    required this.type,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = formNotifier.selectedRuc == type;
    return GestureDetector(
      onTap: () => formNotifier.changeRucType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF66CFFF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF66CFFF)
                : const Color(0xFF0A2B7A),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Text(
              "Tipo de comercio",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF00114A).withValues(alpha: 0.6),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF051858),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
