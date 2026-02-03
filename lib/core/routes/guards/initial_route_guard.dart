import 'package:auto_route/auto_route.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/managers/auth/storage/token_manager.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/main.dart';

/// Guard para decidir la ruta inicial basado en el estado de autenticación
class InitialRouteGuard extends AutoRouteGuard {
  final AuthManager _authManager;
  final TokenManager _tokenManager;

  InitialRouteGuard()
    : _authManager = getIt<AuthManager>(),
      _tokenManager = getIt<TokenManager>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final refreshToken = await _authManager.getCurrentRefreshToken();

    if (refreshToken != null) {
      // Verificar si los datos están completos para decidir la ruta inicial
      final isCompleteData = await _tokenManager.getIsCompleteData();

      if (isCompleteData == true) {
        resolver.redirectUntil(
          const DashboardRoute(children: [ProductosShell()]),
        );
      } else {
        const rucType = RucType.ruc10;

        // Usar replaceAll para limpiar el stack y evitar que haya botón de regresar
        router.replaceAll([
          DashboardRoute(children: [ValidationRoute(rucType: rucType)]),
        ]);
        resolver.next(false);
      }
    } else {
      resolver.redirectUntil(const LoginRoute());
    }
  }
}
