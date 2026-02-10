import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Shell route para la sección de QR
@RoutePage()
class QrShell extends StatelessWidget {
  const QrShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
