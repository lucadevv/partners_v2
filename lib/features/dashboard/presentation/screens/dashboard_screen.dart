import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/theme/app_colors_ligth.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget implements AutoRouteWrapper {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.shopping_bag, 'label': 'Productos'},
      {'icon': Icons.payment, 'label': 'Pagar'},
      {'icon': Icons.favorite, 'label': 'Para Ti'},
      {'icon': Icons.person, 'label': 'Cuenta'},
    ];
    final visibleRoutes = [
      '/dashboard/home',
      '/dashboard/pagar',
      '/dashboard/para-ti',
      '/dashboard/cuenta',
    ];

    // Obtener la ruta actual
    final currentPath = context.router.currentPath;
    final isValidationRoute = currentPath.contains('/validation');
    
    // Si estamos en la ruta de validación, mostrar solo el AutoRouter sin tabs
    if (isValidationRoute) {
      return Scaffold(
        backgroundColor: const Color(0XFFE3FFFC),
        body: const AutoRouter(),
      );
    }

    // Si no estamos en validación, mostrar los tabs
    return AutoTabsRouter.pageView(
      physics: const NeverScrollableScrollPhysics(),
      routes: const [
        ProductosShell(),
        PagarShell(),
        ParaTiShell(),
        CuentaShell(),
      ],
      builder: (context, child, _) {
        final tabsRouter = AutoTabsRouter.of(context);
        final tabsPath = tabsRouter.currentPath;
        final isVisible = visibleRoutes.any((route) => tabsPath.startsWith(route));

        return Scaffold(
          backgroundColor: const Color(0XFFE3FFFC),
          body: Stack(
            children: [
              child,
              if (isVisible) ...[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 79,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColorsLigth.onPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemNavbar(
                            icon: navItems[0]['icon'] as IconData,
                            label: navItems[0]['label'] as String,
                            isActive: tabsRouter.activeIndex == 0,
                            onTap: () => tabsRouter.setActiveIndex(0),
                          ),
                          ItemNavbar(
                            icon: navItems[1]['icon'] as IconData,
                            label: navItems[1]['label'] as String,
                            isActive: tabsRouter.activeIndex == 1,
                            onTap: () => tabsRouter.setActiveIndex(1),
                          ),
                          Container(
                            height: 92,
                            width: 110,
                            color: Colors.transparent,
                          ),
                          ItemNavbar(
                            icon: navItems[2]['icon'] as IconData,
                            label: navItems[2]['label'] as String,
                            isActive: tabsRouter.activeIndex == 2,
                            onTap: () => tabsRouter.setActiveIndex(2),
                          ),
                          ItemNavbar(
                            icon: navItems[3]['icon'] as IconData,
                            label: navItems[3]['label'] as String,
                            isActive: tabsRouter.activeIndex == 3,
                            onTap: () => tabsRouter.setActiveIndex(3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    // Aquí se pueden agregar BlocProviders si es necesario
    return this;
  }
}

class ItemNavbar extends StatelessWidget {
  const ItemNavbar({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isActive)
                Transform.rotate(
                  angle: -24.2 * (math.pi / 180),
                  child: Container(
                    height: 31,
                    width: 31,
                    decoration: BoxDecoration(
                      color: context.appColor.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              Icon(
                icon,
                size: 26,
                color: !isActive
                    ? context.appColor.onPrimary
                    : AppColorsLigth.onPrimary,
              ),
            ],
          ),
          4.spaceh,
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: context.appColor.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
