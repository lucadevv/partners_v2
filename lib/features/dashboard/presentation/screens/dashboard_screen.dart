import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/utils/icon_paths.dart';
import 'package:partners/core/widgets/svg_icon_widget.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget implements AutoRouteWrapper {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = context.router.currentPath;
    final isValidationRoute = currentPath.contains('/validation');

    // If we're on validation route, show only AutoRouter without navbar
    if (isValidationRoute) {
      return Scaffold(
        backgroundColor: const Color(0XFFE3FFFC),
        body: const AutoRouter(),
      );
    }

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

        return Scaffold(
          extendBody: true, // Allow body to extend behind navbar
          body: Stack(
            children: [
              // Main content
              child,
              // Custom navbar - NO ClipPath, just regular container with notch using Stack
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 97,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFE3DDDD),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Navigation items background - with notch cutout
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Home
                                _NavItem(
                                  iconPath: IconPaths.home,
                                  label: 'Inicio',
                                  isActive: tabsRouter.activeIndex == 0,
                                  onTap: () => tabsRouter.setActiveIndex(0),
                                ),
                                // Chat/Promos
                                _NavItem(
                                  iconPath: IconPaths.chat,
                                  label: 'Promos',
                                  isActive: tabsRouter.activeIndex == 1,
                                  onTap: () => tabsRouter.setActiveIndex(1),
                                ),
                                // Spacer for QR button
                                const SizedBox(width: 50),
                                // Users
                                _NavItem(
                                  iconPath: IconPaths.settings,
                                  label: 'usuarios',
                                  isActive: tabsRouter.activeIndex == 3,
                                  onTap: () => tabsRouter.setActiveIndex(3),
                                ),
                                // Menu
                                _NavItem(
                                  iconPath: IconPaths.profile,
                                  label: 'Menú',
                                  isActive: tabsRouter.activeIndex == 4,
                                  onTap: () => tabsRouter.setActiveIndex(4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // QR Button (centered and elevated) - positioned above navbar
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () => tabsRouter.setActiveIndex(2),
                            child: Container(
                              width: 80.54,
                              height: 80.54,
                              decoration: BoxDecoration(
                                color: const Color(0xFF242760),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgIconWidget(
                                    assetPath: IconPaths.qr,
                                    width: 35,
                                    height: 35,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 2),
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
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}

class _NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF242760) : const Color(0xFFC7C6C5);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgIconWidget(
            assetPath: iconPath,
            width: 34,
            height: 34,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontFamily: 'Figtree',
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
