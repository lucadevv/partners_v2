import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Shell route que envuelve todas las rutas privadas
/// Proporciona un layout común para las pantallas autenticadas
@RoutePage()
class AppShellRoute extends StatelessWidget {
  const AppShellRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
