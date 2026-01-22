import 'package:flutter/material.dart';

/// Widget animado de loading con 3 dots para pantalla de Validation Complete
class ValidationLoadingDots extends StatefulWidget {
  const ValidationLoadingDots({super.key});

  @override
  State<ValidationLoadingDots> createState() => _ValidationLoadingDotsState();
}

class _ValidationLoadingDotsState extends State<ValidationLoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (_controller.value - delay) % 1.0;
            final scale = value < 0.5
                ? 1.0 + (value * 0.4)
                : 1.0 + ((1.0 - value) * 0.4);

            return Transform.scale(
              scale: scale,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF66CFFF),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
