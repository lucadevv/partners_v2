import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/core/utils/icon_paths.dart';
import 'package:partners/core/widgets/svg_icon_widget.dart';
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
      final roleService = getIt<RoleService>();
      
      // Limpiar autenticación y rol
      await authManager.logout();
      roleService.clearUser();
      
      if (context.mounted) {
        context.router.replaceAll([const LoginRoute()]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2B69), // Azul oscuro según diseño
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Herramientas Smart',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          _buildMenuCard(
            iconPath: IconPaths.survey,
            title: 'Encuestas\nSmart',
            onTap: () {
              // TODO: Navigate to surveys
            },
          ),
          _buildMenuCard(
            iconPath: IconPaths.promotion,
            title: 'Promociones\nSmart',
            onTap: () {
              // TODO: Navigate to promotions
            },
          ),
          _buildMenuCard(
            iconPath: IconPaths.marketStudy,
            title: 'Estudios de\nMercado\nSmart',
            onTap: () {
              // TODO: Navigate to market studies
            },
          ),
          _buildMenuCard(
            iconPath: IconPaths.dashboard,
            title: 'Ir a mi\nDashboard',
            onTap: () {
              // TODO: Navigate to dashboard
            },
          ),
          _buildMenuCard(
            iconPath: IconPaths.store,
            title: 'Sucursales',
            onTap: () {
              // Navigate to branches
            },
          ),
          _buildMenuCard(
            iconPath: IconPaths.receipt,
            title: 'Recibos\nSmart',
            onTap: () {
              // TODO: Navigate to receipts
            },
          ),
          _buildMenuCard(
            iconPath: IconPaths.analytics,
            title: 'Estadísticas',
            onTap: () {
              // TODO: Navigate to statistics
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgIconWidget(
              assetPath: iconPath,
              width: 55,
              height: 55,
              color: const Color(0xFF0F2B69),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF0F2B69),
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Figtree',
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
