import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Shell route para la sección de Productos
@RoutePage()
class ProductosShell extends StatelessWidget {
  const ProductosShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
