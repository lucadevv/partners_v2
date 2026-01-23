import 'package:auto_route/auto_route.dart';
import 'package:partners/core/routes/private_routes.dart';
import 'package:partners/core/routes/public_routes.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Rutas públicas (sin autenticación)
        ...PublicRoutes.routes(),
        // Rutas privadas (requieren autenticación) con shell route
        ...PrivateRoutes.routes(),
      ];
}
