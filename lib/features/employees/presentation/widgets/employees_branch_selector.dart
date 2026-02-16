import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/employees/domain/entities/branch_option_entity.dart';
import 'package:partners/features/employees/presentation/screens/employees_screen_strings.dart';

/// Selector de sucursal (dropdown) para la lista de empleados.
class EmployeesBranchSelector extends StatelessWidget {
  const EmployeesBranchSelector({
    super.key,
    required this.branchOptions,
    required this.selectedBranchId,
    required this.onChanged,
  });

  final List<BranchOptionEntity> branchOptions;
  final String? selectedBranchId;
  final void Function(String? branchId) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          EmployeesScreenStrings.branchSelectorLabel,
          style: context.appTextTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        8.spaceh,
        DropdownButtonFormField<String>(
          value: selectedBranchId,
          decoration: InputDecoration(
            hintText: EmployeesScreenStrings.branchSelectorHint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Todas'),
            ),
            ...branchOptions.map(
              (b) => DropdownMenuItem<String>(
                value: b.id,
                child: Text(b.name),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
