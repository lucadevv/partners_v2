import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// AutoTabsRoute para navegación con tabs
/// Permite cambiar entre diferentes pantallas usando tabs en la parte inferior
@RoutePage()
class MainTabsRoute extends StatelessWidget {
  const MainTabsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);

    return Scaffold(
      body: const AutoRouter(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabsRouter.activeIndex,
        onTap: tabsRouter.setActiveIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pagar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Para Ti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }
}
