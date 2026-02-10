import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/routes/app_routes.gr.dart';

@RoutePage()
class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;
    
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'QR Code',
          style: TextStyle(
            color: Color(0xFF0F2B69),
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to QR scan screen
            context.router.push(const QrScanRoute());
          },
          child: const Text('Escanear QR'),
        ),
      ),
    );
  }
}
