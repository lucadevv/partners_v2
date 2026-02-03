import 'package:auto_route/auto_route.dart';
import 'package:partners/core/managers/auth/storage/token_manager.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/main.dart';

class CompleteDataGuard extends AutoRouteGuard {
  final TokenManager _tokenManager;

  CompleteDataGuard() : _tokenManager = getIt<TokenManager>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isCompleteData = await _tokenManager.getIsCompleteData();

    if (isCompleteData == false) {
      const rucType = RucType.ruc10;

      router.replaceAll([
        DashboardRoute(children: [ValidationRoute(rucType: rucType)]),
      ]);
      resolver.next(false);
    } else {
      resolver.next(true);
    }
  }
}
