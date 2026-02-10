import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Shell route para la sección de Home
@RoutePage()
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
