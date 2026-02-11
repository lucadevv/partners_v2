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
        // Protected routes with CompleteDataGuard - usando shells para navegación anidada
        AutoRoute(
          path: 'home',
          guards: [CompleteDataGuard()],
          page: HomeShell.page,
          children: [
            AutoRoute(initial: true, path: '', page: HomeRoute.page),
            // Rutas hijas de Home - herramientas smart
            AutoRoute(path: 'branches', page: BranchesRoute.page),
            AutoRoute(path: 'create-branch', page: CreateBranchRoute.page),
            AutoRoute(path: 'select-category', page: SelectCategoryRoute.page),
            AutoRoute(
              path: 'select-subcategory',
              page: SelectSubCategoryRoute.page,
            ),
            AutoRoute(
              path: 'configure-schedule',
              page: ConfigureScheduleRoute.page,
            ),
            AutoRoute(path: 'add-workers', page: AddWorkersRoute.page),
            AutoRoute(path: 'buy-points', page: BuyPointsRoute.page),
            AutoRoute(path: 'issue-points', page: IssuePointsRoute.page),
            AutoRoute(path: 'redeem-points', page: RedeemPointsRoute.page),
            AutoRoute(path: 'prizes', page: PrizesRoute.page),
            AutoRoute(path: 'analytics', page: AnalyticsRoute.page),
            AutoRoute(path: 'smart-card', page: SmartCardRoute.page),
            AutoRoute(path: 'more', page: MoreToolsRoute.page),
            AutoRoute(path: 'transactions', page: TransactionsRoute.page),
            AutoRoute(
              path: 'transaction-detail',
              page: TransactionDetailRoute.page,
            ),
            AutoRoute(
              path: 'issue-points-success',
              page: IssuePointsSuccessRoute.page,
            ),
          ],
        ),
        AutoRoute(
          path: 'promos',
          guards: [CompleteDataGuard()],
          page: PromosShell.page,
          children: [
            AutoRoute(initial: true, path: '', page: PromosRoute.page),
            AutoRoute(path: 'promo-detail', page: PromoDetailRoute.page),
            AutoRoute(
              path: 'create-basic-promo',
              page: CreateBasicPromoRoute.page,
            ),
            AutoRoute(
              path: 'create-segmented-promo',
              page: CreateSegmentedPromoRoute.page,
            ),
            AutoRoute(path: 'promo-map', page: PromoMapRoute.page),
          ],
        ),
        AutoRoute(
          path: 'qr',
          guards: [CompleteDataGuard()],
          page: QrShell.page,
          children: [
            AutoRoute(initial: true, path: '', page: QrRoute.page),
            AutoRoute(path: 'scan', page: QrScanRoute.page),
          ],
        ),
        AutoRoute(
          path: 'users',
          guards: [CompleteDataGuard()],
          page: UsersShell.page,
          children: [
            AutoRoute(initial: true, path: '', page: UsersRoute.page),
          ],
        ),
        AutoRoute(
          path: 'menu',
          guards: [CompleteDataGuard()],
          page: MenuShell.page,
          children: [
            AutoRoute(initial: true, path: '', page: MenuRoute.page),
            // Aquí se pueden agregar más rutas hijas de Menu
          ],
        ),
        // AutoRoute(
        //   path: 'products',
        //   guards: [CompleteDataGuard()],
        //   page: ProductosShell.page,
        //   children: [
        //     AutoRoute(initial: true, path: '', page: ProductosRoute.page),
        //   ],
        // ),
        // AutoRoute(
        //   path: 'pagar',
        //   guards: [CompleteDataGuard()],
        //   page: PagarShell.page,
        //   children: [
        //     AutoRoute(initial: true, path: '', page: PagarRoute.page),
        //     // Aquí se pueden agregar más rutas hijas de Pagar
        //     // AutoRoute(
        //     //   path: 'payment-methods',
        //     //   page: PaymentMethodsRoute.page,
        //     // ),
        //   ],
        // ),
        // AutoRoute(
        //   path: 'para-ti',
        //   guards: [CompleteDataGuard()],
        //   page: ParaTiShell.page,
        //   children: [
        //     AutoRoute(initial: true, path: '', page: ParaTiRoute.page),
        //     // Aquí se pueden agregar más rutas hijas de Para Ti
        //     // AutoRoute(
        //     //   path: 'recommendations',
        //     //   page: RecommendationsRoute.page,
        //     // ),
        //   ],
        // ),
        // AutoRoute(
        //   path: 'cuenta',
        //   guards: [CompleteDataGuard()],
        //   page: CuentaShell.page,
        //   children: [
        //     AutoRoute(initial: true, path: '', page: CuentaRoute.page),
        //     // Aquí se pueden agregar más rutas hijas de Cuenta
        //     // AutoRoute(
        //     //   path: 'profile',
        //     //   page: ProfileRoute.page,
        //     // ),
        //     // AutoRoute(
        //     //   path: 'settings',
        //     //   page: SettingsRoute.page,
        //     // ),
        //   ],
        // ),
      ],
    ),
  ];
}
