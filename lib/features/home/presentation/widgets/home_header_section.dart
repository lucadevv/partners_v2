import 'package:flutter/material.dart';

/// Widget for the header section with title
/// Follows Single Responsibility Principle (SRP)
class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 60,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: const Text(
        'Mis herramientas Smart',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          fontFamily: 'Figtree',
        ),
      ),
    );
  }
}
