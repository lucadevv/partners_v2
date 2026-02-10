import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';

/// Widget para mostrar un chip de categoría
/// Sigue el principio de Single Responsibility (SRP)
class CategoriaChipWidget extends StatelessWidget {
  final String nombre;
  final IconData icono;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoriaChipWidget({
    required this.nombre,
    required this.icono,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              size: 18,
              color: isSelected
                  ? context.appColor.onSecondary
                  : context.appColor.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(nombre),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: context.appColor.secondary,
        checkmarkColor: context.appColor.onSecondary,
        labelStyle: TextStyle(
          color: isSelected
              ? context.appColor.onSecondary
              : context.appColor.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
