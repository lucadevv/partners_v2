import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/employees/domain/entities/employee_entity.dart';
import 'package:partners/features/employees/presentation/screens/create_employee_screen_strings.dart';

/// Card de un empleado en la lista.
class EmployeeCardWidget extends StatelessWidget {
  const EmployeeCardWidget({
    super.key,
    required this.employee,
    this.onTap,
  });

  final EmployeeEntity employee;
  final VoidCallback? onTap;

  static const double _imageSize = 56;
  static const double _cardRadius = 12;

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(
          color: context.appColor.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildPhoto(context),
            16.spacew,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    employee.name,
                    style: context.appTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  4.spaceh,
                  Text(
                    CreateEmployeeScreenStrings.roleDisplayName(employee.role),
                    style: context.appTextTheme.bodySmall?.copyWith(
                      color: context.appColor.onSurfaceVariant,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_cardRadius),
          child: child,
        ),
      );
    }
    return child;
  }

  Widget _buildPhoto(BuildContext context) {
    return Container(
      width: _imageSize,
      height: _imageSize,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appColor.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(_imageSize / 2),
      ),
      child: employee.photo != null && employee.photo!.isNotEmpty
          ? Image.network(
              employee.photo!,
              fit: BoxFit.cover,
              width: _imageSize,
              height: _imageSize,
            )
          : Icon(
              Icons.person,
              size: 28,
              color: context.appColor.onSurfaceVariant,
            ),
    );
  }
}
