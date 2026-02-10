import 'package:get_it/get_it.dart';
import 'package:partners/core/services/role_service.dart';

/// Inyección de dependencias para el servicio de roles
class RoleInjection {
  final GetIt _getIt;

  RoleInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    if (!_getIt.isRegistered<RoleService>()) {
      _getIt.registerLazySingleton<RoleService>(() => RoleService());
    }
  }
}
