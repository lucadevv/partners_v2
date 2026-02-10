import 'package:flutter/material.dart';

/// Widget for oval background behind tools section
/// Follows Single Responsibility Principle (SRP)
class HomeToolsOvalBackground extends StatelessWidget {
  const HomeToolsOvalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ToolsOvalClipper(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF0F2B69),
      ),
    );
  }
}

/// Custom clipper for oval shape behind tools
class _ToolsOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Parte superior completamente recta
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);

    // Crear un óvalo elíptico que se curve hacia ABAJO en la parte inferior
    // El óvalo debe cubrir todo el alto (título + grid) y la curva debe estar en la parte inferior
    // Usar curvas bezier cúbicas para crear la curva elíptica visible en la parte inferior
    final controlPoint1 = Offset(size.width * 3.0, size.height * 1.3);
    final controlPoint2 = Offset(-size.width * 2.0, size.height * 1.3);
    final endPoint = Offset(0, 0);

    // Crear la curva elíptica usando cubic bezier
    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // Cerrar el path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
