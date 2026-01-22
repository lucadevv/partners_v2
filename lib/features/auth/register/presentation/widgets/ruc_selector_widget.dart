import 'package:flutter/material.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';

enum TipoRuc { ruc10, ruc15, ruc20 }

/// Widget selector de tipo de RUC (10, 15, 20) - Diseño de partners2.pen
class RucSelectorWidget extends StatelessWidget {
  final TipoRuc? selectedTipo;
  final Function(TipoRuc) onTipoSelected;

  const RucSelectorWidget({
    super.key,
    required this.selectedTipo,
    required this.onTipoSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RucBox(
            label: 'Tipo de comercio',
            value: 'RUC 10',
            isSelected: selectedTipo == TipoRuc.ruc10,
            onTap: () => onTipoSelected(TipoRuc.ruc10),
          ),
        ),
        12.spacew,
        Expanded(
          child: _RucBox(
            label: 'Tipo de comercio',
            value: 'RUC 15',
            isSelected: selectedTipo == TipoRuc.ruc15,
            onTap: () => onTipoSelected(TipoRuc.ruc15),
          ),
        ),
        12.spacew,
        Expanded(
          child: _RucBox(
            label: 'Tipo de comercio',
            value: 'RUC 20',
            isSelected: selectedTipo == TipoRuc.ruc20,
            onTap: () => onTipoSelected(TipoRuc.ruc20),
          ),
        ),
      ],
    );
  }
}

class _RucBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _RucBox({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF00114A).withOpacity(0.6),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF051858),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
