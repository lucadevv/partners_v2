import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Shell route para la sección de Usuarios
@RoutePage()
class UsersShell extends StatelessWidget {
  const UsersShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
