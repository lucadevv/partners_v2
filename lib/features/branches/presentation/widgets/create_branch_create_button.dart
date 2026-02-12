import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_keys.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';

/// Botón fijo inferior "Crear nueva sucursal".
class CreateBranchCreateButton extends StatelessWidget {
  final CreateBranchFormNotifier formNotifier;
  final VoidCallback? onPressed;

  const CreateBranchCreateButton({
    super.key,
    required this.formNotifier,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = formNotifier.isFormComplete;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        key: const Key(CreateBranchScreenKeys.createButton),
        onPressed: enabled ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward, size: 22),
            20.spacew,
            Text(
              CreateBranchScreenStrings.createBranchButton,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Figtree',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
