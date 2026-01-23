import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProductosScreen extends StatelessWidget {
  const ProductosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: const Center(
        child: Text('Productos Screen'),
      ),
    );
  }
}
