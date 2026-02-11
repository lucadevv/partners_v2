import 'package:auto_route/auto_route.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/main.dart';

/// Guard para decidir la ruta inicial basado en el estado de autenticación
class InitialRouteGuard extends AutoRouteGuard {
  final AuthManager _authManager;

  InitialRouteGuard() : _authManager = getIt<AuthManager>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final refreshToken = await _authManager.getCurrentRefreshToken();

    if (refreshToken != null) {
      // Restaurar usuario en RoleService para que permisos (ej. superadmin) funcionen
      final user = await _authManager.getCurrentUser();
      if (user != null) {
        getIt<RoleService>().setUser(user);
      }
      resolver.redirectUntil(
        const DashboardRoute(children: [ProductosShell()]),
      );
    } else {
      resolver.redirectUntil(const LoginRoute());
    }
  }
}
