import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/features/productos/domain/entities/producto_entity.dart';
import 'package:partners/features/productos/presentation/widgets/producto_card_widget.dart';

/// Widget para mostrar productos destacados en un carrusel horizontal
/// Sigue el principio de Single Responsibility (SRP)
class ProductosDestacadosWidget extends StatelessWidget {
  final List<ProductoEntity> productos;

  const ProductosDestacadosWidget({
    required this.productos,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: context.appColor.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Productos Destacados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.appColor.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ProductoCardWidget(producto: productos[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
