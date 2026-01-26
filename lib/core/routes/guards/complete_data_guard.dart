import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:partners/core/managers/auth/storage/token_manager.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/main.dart';

class CompleteDataGuard extends AutoRouteGuard {
  final TokenManager _tokenManager;

  CompleteDataGuard() : _tokenManager = getIt<TokenManager>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isCompleteData = await _tokenManager.getIsCompleteData();

    if (kDebugMode) {
      debugPrint(
        'CompleteDataGuard: isCompleteData = $isCompleteData, routeName = ${resolver.route.name}',
      );
    }

    if (isCompleteData == false) {
      if (kDebugMode) {
        debugPrint(
          'CompleteDataGuard: Datos incompletos. Redirigiendo a ValidationRoute.',
        );
      }

      router.replaceAll([
        const DashboardRoute(children: [ValidationRoute()]),
      ]);
      resolver.next(false);
    } else {
      if (kDebugMode) {
        debugPrint('CompleteDataGuard: Datos completos. Permitiendo acceso.');
      }
      resolver.next(true);
    }
  }
}
