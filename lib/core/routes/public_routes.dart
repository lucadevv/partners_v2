import 'package:auto_route/auto_route.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/routes/guards/initial_route_guard.dart';

class PublicRoutes {
  static List<AutoRoute> routes() => [
    AutoRoute(
      page: SplashRoute.page,
      initial: true,
      guards: [InitialRouteGuard()],
    ),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: ValidationRoute.page),
    AutoRoute(page: DocumentScanRoute.page),
    AutoRoute(page: DocumentSuccessRoute.page),
    AutoRoute(page: BusinessValidationRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: RegistrationSuccessRoute.page),
  ];
}
