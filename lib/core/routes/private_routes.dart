import 'package:auto_route/auto_route.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/routes/guards/auth_guard.dart';
import 'package:partners/core/routes/guards/complete_data_guard.dart';

class PrivateRoutes {
  static List<AutoRoute> routes() => [
    AutoRoute(
      path: '/dashboard',
      guards: [AuthGuard()],
      page: DashboardRoute.page,
      children: [
        // Ruta de validación - SIN CompleteDataGuard (debe ser accesible cuando datos incompletos)
        // Esta será la ruta inicial cuando los datos estén incompletos
        AutoRoute(path: 'validation', page: ValidationRoute.page),
        // Rutas protegidas con CompleteDataGuard
        AutoRoute(
          path: 'home',
          guards: [CompleteDataGuard()],
          page: ProductosShell.page,
          children: [
            AutoRoute(initial: true, path: '', page: ProductosRoute.page),
            // Aquí se pueden agregar más rutas hijas de Productos
            // AutoRoute(
            //   path: 'detail',
            //   page: ProductDetailRoute.page,
            // ),
          ],
        ),
        AutoRoute(
          path: 'pagar',
          guards: [CompleteDataGuard()],
          page: PagarShell.page,
          children: [
            AutoRoute(initial: true, path: '', page: PagarRoute.page),
            // Aquí se pueden agregar más rutas hijas de Pagar
            // AutoRoute(
            //   path: 'payment-methods',
            //   page: PaymentMethodsRoute.page,
            // ),
          ],
        ),
        AutoRoute(
          path: 'para-ti',
          guards: [CompleteDataGuard()],
          page: ParaTiShell.page,
          children: [
            AutoRoute(initial: true, path: '', page: ParaTiRoute.page),
            // Aquí se pueden agregar más rutas hijas de Para Ti
            // AutoRoute(
            //   path: 'recommendations',
            //   page: RecommendationsRoute.page,
            // ),
          ],
        ),
        AutoRoute(
          path: 'cuenta',
          guards: [CompleteDataGuard()],
          page: CuentaShell.page,
          children: [
            AutoRoute(initial: true, path: '', page: CuentaRoute.page),
            // Aquí se pueden agregar más rutas hijas de Cuenta
            // AutoRoute(
            //   path: 'profile',
            //   page: ProfileRoute.page,
            // ),
            // AutoRoute(
            //   path: 'settings',
            //   page: SettingsRoute.page,
            // ),
          ],
        ),
      ],
    ),
  ];
}
