import 'package:auto_route/auto_route.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/core/utils/utils.dart';
import 'package:partners/core/widgets/widgets.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget implements AutoRouteWrapper {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visibleRoutes = [
      '/dashboard/home',
      '/dashboard/promos',
      '/dashboard/qr',
      '/dashboard/users',
      '/dashboard/menu',
    ];

    // If not in validation, show tabs with custom navbar
    return AutoTabsRouter.pageView(
      physics: const NeverScrollableScrollPhysics(),
      routes: [
        const HomeRoute(),
        const PromosRoute(),
        const QrRoute(),
        const UsersRoute(),
        const MenuRoute(),
      ],
      builder: (context, child, _) {
        final tabsRouter = AutoTabsRouter.of(context);
        final activeIndex = tabsRouter.activeIndex;
        final isVisible = visibleRoutes.contains(tabsRouter.currentPath);
        // Función para obtener el color según si está activo
        Color getIconColor(int index) {
          return activeIndex == index ? const Color(0xFF242760) : Colors.black;
        }

        return Scaffold(
          extendBody: true, // Allow body to extend behind navbar
          body: child,
          bottomNavigationBar: isVisible
              ? CircleNavBar(
                  activeIcons: [
                    // Solo icono sin texto
                    SvgIconWidget(
                      assetPath: IconPaths.home,
                      width: 34,
                      height: 34,
                      color: getIconColor(0),
                    ),
                    // Solo icono sin texto
                    SvgIconWidget(
                      assetPath: IconPaths.promos,
                      width: 34,
                      height: 34,
                      color: getIconColor(1),
                    ),
                    // QR con texto (único que tiene texto)
                    const _QrButtonWidget(),
                    // Solo icono sin texto
                    SvgIconWidget(
                      assetPath: IconPaths.users,
                      width: 34,
                      height: 34,
                      color: getIconColor(3),
                    ),
                    // Solo icono sin texto
                    SvgIconWidget(
                      assetPath: IconPaths.menu,
                      width: 34,
                      height: 34,
                      color: getIconColor(4),
                    ),
                  ],
                  inactiveIcons: [
                    // Solo icono sin texto
                    SvgIconWidget(
                      assetPath: IconPaths.home,
                      width: 34,
                      height: 34,
                      color: getIconColor(0),
                    ),
                    // Solo icono sin texto
                    SvgIconWidget(
                      assetPath: IconPaths.promos,
                      width: 34,
                      height: 34,
                      color: getIconColor(1),
                    ),
                    // QR con texto (único que tiene texto)
                    const _QrButtonWidget(),
                    // Solo icono sin texto
                    SvgIconWidget(
                      assetPath: IconPaths.users,
                      width: 34,
                      height: 34,
                      color: getIconColor(3),
                    ),
                    // Solo icono sin texto
                    SvgIconWidget(
                      assetPath: IconPaths.menu,
                      width: 34,
                      height: 34,
                      color: getIconColor(4),
                    ),
                  ],
                  color: Colors.white,
                  circleColor: const Color(0xFF242760),
                  height: 97,
                  circleWidth: 80.54,
                  activeIndex:
                      2, // Siempre mantener el círculo fijo en el QR (índice 2)
                  onTap: (index) {
                    tabsRouter.setActiveIndex(index);
                  },
                  cornerRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                  shadowColor: Colors.black.withValues(alpha: 0.05),
                  circleShadowColor: Colors.black.withValues(alpha: 0.2),
                  elevation: 10,
                  tabCurve:
                      Curves.linear, // Sin animación suave, cambio directo
                )
              : null,
        );
      },
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}

// Widget separado para el QR que no se reconstruye
class _QrButtonWidget extends StatelessWidget {
  const _QrButtonWidget();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIconWidget(
            assetPath: IconPaths.qr,
            width: 35,
            height: 35,
            color: Colors.white,
          ),
          const Text(
            'QR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              fontFamily: 'Figtree',
            ),
          ),
        ],
      ),
    );
  }
}
