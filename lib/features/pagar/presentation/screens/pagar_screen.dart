import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PagarScreen extends StatelessWidget {
  const PagarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
      ),
      body: const Center(
        child: Text('Pagar Screen'),
      ),
    );
  }
}
