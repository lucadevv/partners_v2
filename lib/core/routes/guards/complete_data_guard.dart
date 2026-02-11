import 'package:auto_route/auto_route.dart';

class CompleteDataGuard extends AutoRouteGuard {
  CompleteDataGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    resolver.next(true);
  }
}
