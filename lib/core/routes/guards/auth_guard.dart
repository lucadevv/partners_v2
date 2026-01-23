import 'package:auto_route/auto_route.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/routes/app_routes.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/main.dart';

/// Guard para proteger rutas privadas
/// Verifica si el usuario está autenticado antes de permitir el acceso
class AuthGuard extends AutoRouteGuard {
  final AuthManager _authManager;
  final AppRouter _appRouter;

  AuthGuard()
      : _appRouter = getIt<AppRouter>(),
        _authManager = getIt<AuthManager>() {
    _setupAuthListener();
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final refreshToken = await _authManager.getCurrentRefreshToken();
    if (refreshToken != null) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(const LoginRoute());
    }
  }

  void _setupAuthListener() {
    _authManager.authStatusStream.listen((status) {
      if (status == AuthStatus.unauthenticated) {
        _appRouter.replaceAll([const LoginRoute()]);
      }
    });
  }
}
