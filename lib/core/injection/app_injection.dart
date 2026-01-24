import 'package:get_it/get_it.dart';
import 'package:partners/core/config/app_config.dart';
import 'package:partners/core/injection/auth/auth_injection.dart';
import 'package:partners/core/routes/app_routes.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/services/network/dio_services_impl.dart';
import 'package:partners/core/utils/logger/app_logger.dart';

class AppInjection {
  final GetIt _getIt;
  final String _baseUrl;

  AppInjection({required GetIt getIt, required String baseUrl})
      : _getIt = getIt,
        _baseUrl = baseUrl {
    _init();
  }

  void _init() {
    try {
      if (!_getIt.isRegistered<AppRouter>()) {
        _getIt.registerLazySingleton<AppRouter>(
          () {
            try {
              return AppRouter();
            } catch (e, stackTrace) {
              AppLogger.error('Error al crear AppRouter', e, stackTrace, 'AppInjection');
              rethrow;
            }
          },
        );
      }

      if (!_getIt.isRegistered<ApiServices>()) {
        final validatedUrl = _baseUrl.isEmpty
            ? AppConfig.getValidatedBaseUrl()
            : _baseUrl;
        _getIt.registerLazySingleton<ApiServices>(
          () => DioApiServicesImpl(validatedUrl),
        );
      }

      AuthInjection(getIt: _getIt);
      AppLogger.info('AppInjection inicializado correctamente', 'AppInjection');
    } catch (e, stackTrace) {
      AppLogger.error('Error en AppInjection', e, stackTrace, 'AppInjection');
      rethrow;
    }
  }
}
