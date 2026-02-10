import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Shell route para la sección de Menu
@RoutePage()
class MenuShell extends StatelessWidget {
  const MenuShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
