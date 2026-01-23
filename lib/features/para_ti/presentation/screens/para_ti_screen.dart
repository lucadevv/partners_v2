import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ParaTiScreen extends StatelessWidget {
  const ParaTiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Para Ti'),
      ),
      body: const Center(
        child: Text('Para Ti Screen'),
      ),
    );
  }
}
