import 'package:flutter/foundation.dart';
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
    try {
      // Registrar AppRouter de forma lazy (solo se crea cuando se necesita)
      // En modo debug, puede haber problemas con hot reload, así que verificamos si ya existe
      if (!_getIt.isRegistered<AppRouter>()) {
        debugPrint('📱 Registrando AppRouter...');
        _getIt.registerLazySingleton<AppRouter>(
          () {
            debugPrint('📱 Inicializando AppRouter (lazy)...');
            try {
              final router = AppRouter();
              debugPrint('✅ AppRouter inicializado correctamente');
              return router;
            } catch (e, stackTrace) {
              debugPrint('❌ Error al crear AppRouter: $e');
              debugPrint('Stack trace: $stackTrace');
              rethrow;
            }
          },
        );
        debugPrint('✅ AppRouter registrado en GetIt');
      } else {
        debugPrint('⚠️ AppRouter ya está registrado (posible hot reload)');
      }
      
      // Registrar ApiServices de forma lazy
      if (!_getIt.isRegistered<ApiServices>()) {
        final baseUrl = _baseUrl.isEmpty ? 'https://api.example.com' : _baseUrl;
        _getIt.registerLazySingleton<ApiServices>(
          () {
            debugPrint('🌐 Inicializando ApiServices...');
            return DioApiServicesImpl(baseUrl);
          },
        );
      }

      // Inicializar inyecciones de auth (también lazy)
      AuthInjection(getIt: _getIt);
      
      debugPrint('✅ AppInjection inicializado correctamente');
    } catch (e, stackTrace) {
      // Log del error pero no bloquear la inicialización
      debugPrint('❌ Error en AppInjection: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
