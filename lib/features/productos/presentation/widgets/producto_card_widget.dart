import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/productos/domain/domain.dart';

/// Widget para mostrar una tarjeta de producto
/// Sigue el principio de Single Responsibility (SRP)
class ProductoCardWidget extends StatelessWidget {
  final ProductoEntity producto;

  const ProductoCardWidget({
    required this.producto,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del producto
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                color: context.appColor.surfaceContainerHighest,
                child: producto.imagenUrl.isNotEmpty
                    ? Image.network(
                        producto.imagenUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: context.appColor.onSurfaceVariant,
                          );
                        },
                      )
                    : Icon(
                        Icons.image,
                        size: 48,
                        color: context.appColor.onSurfaceVariant,
                      ),
              ),
            ),
          ),

          // Información del producto
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    producto.descripcion,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.appColor.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (producto.tieneDescuento)
                            Text(
                              'S/ ${producto.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                color: context.appColor.onSurfaceVariant,
                              ),
                            ),
                          Text(
                            'S/ ${producto.precioFinal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.appColor.primary,
                            ),
                          ),
                        ],
                      ),
                      if (producto.tieneDescuento)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: context.appColor.error,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${producto.porcentajeDescuento!.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
