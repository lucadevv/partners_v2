import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// AutoTabsRoute for navigation with tabs
/// Allows switching between different screens using bottom tabs
@RoutePage()
class MainTabsRoute extends StatelessWidget {
  const MainTabsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);

    return Scaffold(
      body: const AutoRouter(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 97,
            child: Stack(
              children: [
                // Navigation bar background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Home
                        _NavItem(
                          icon: Icons.home,
                          label: 'Home',
                          isActive: false,
                          onTap: () {},
                        ),
                        // Promos
                        _NavItem(
                          icon: Icons.local_offer_outlined,
                          label: 'Promos',
                          isActive: false,
                          onTap: () {},
                        ),
                        // Spacer for QR button
                        const SizedBox(width: 50),
                        // Users
                        _NavItem(
                          icon: Icons.people_outline,
                          label: 'Users',
                          isActive: false,
                          onTap: () {},
                        ),
                        // Menu
                        _NavItem(
                          icon: Icons.menu,
                          label: 'Menu',
                          isActive: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                // QR Button (centered and elevated)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Handle QR tap
                    },
                    child: Container(
                      width: 80,
                      height: 80,
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
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(height: 2),
                          Text(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF0F2B69) : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 30),
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
