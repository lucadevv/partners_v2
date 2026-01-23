import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/main.dart';

@RoutePage()
class CuentaScreen extends StatelessWidget {
  const CuentaScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Mostrar diálogo de confirmación
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Está seguro que desea cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final authManager = getIt<AuthManager>();
      await authManager.logout();
      
      if (context.mounted) {
        context.router.replaceAll([const LoginRoute()]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Cuenta Screen'),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
