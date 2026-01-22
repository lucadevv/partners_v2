import 'package:get_it/get_it.dart';
import 'package:partners/core/injection/auth/auth_injection.dart';
import 'package:partners/core/routes/app_routes.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/services/network/dio_services_impl.dart';

class AppInjection {
  final GetIt _getIt;
  final String _baseUrl;

  AppInjection({required GetIt getIt, required String baseUrl})
    : _getIt = getIt,
      _baseUrl = baseUrl {
    _init();
  }

  void _init() {
    if (!_getIt.isRegistered<AppRouter>()) {
      _getIt.registerLazySingleton<AppRouter>(() => AppRouter());
    }
    if (!_getIt.isRegistered<ApiServices>()) {
      _getIt.registerLazySingleton<ApiServices>(
        () => DioApiServicesImpl(_baseUrl),
      );
    }

    // Inicializar inyecciones de auth
    AuthInjection(getIt: _getIt);
  }
}
