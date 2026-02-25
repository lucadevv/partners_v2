import 'package:auto_route/auto_route.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/core/utils/logger/app_logger.dart';
import 'package:partners/main.dart';

/// Tiempo máximo para leer token/usuario del storage; si se excede, se redirige a Login.
const Duration _kInitialGuardTimeout = Duration(seconds: 5);

/// Guard para decidir la ruta inicial basado en el estado de autenticación
class InitialRouteGuard extends AutoRouteGuard {
  final AuthManager _authManager;

  InitialRouteGuard() : _authManager = getIt<AuthManager>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final refreshToken = await _authManager
          .getCurrentRefreshToken()
          .timeout(_kInitialGuardTimeout, onTimeout: () => null);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        final user = await _authManager
            .getCurrentUser()
            .timeout(_kInitialGuardTimeout, onTimeout: () => null);
        if (user != null) {
          getIt<RoleService>().setUser(user);
        }
        resolver.redirectUntil(
          const DashboardRoute(children: [ProductosShell()]),
        );
      } else {
        resolver.redirectUntil(const LoginRoute());
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'InitialRouteGuard: error al resolver ruta inicial',
        e,
        stackTrace,
        'InitialRouteGuard',
      );
      resolver.redirectUntil(const LoginRoute());
    }
  }
}
