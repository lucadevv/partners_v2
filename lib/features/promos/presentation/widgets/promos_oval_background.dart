import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';

/// Óvalo de fondo detrás del header de la pantalla de promos.
/// Usa [context.appColor.primary] (regla: sin colores hardcodeados).
class PromosOvalBackground extends StatelessWidget {
  const PromosOvalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _PromosOvalClipper(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColor.primary,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _PromosOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    final controlPoint1 = Offset(size.width * 3.0, size.height * 1.3);
    final controlPoint2 = Offset(-size.width * 2.0, size.height * 1.3);
    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      0,
      0,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
