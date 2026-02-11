import 'package:get_it/get_it.dart';
import 'package:partners/core/config/app_config.dart';
import 'package:partners/core/injection/auth/auth_injection.dart';
import 'package:partners/core/injection/auth/document_injection.dart';
import 'package:partners/core/injection/auth/validation_injeciton.dart';
import 'package:partners/core/injection/branches/branches_injection.dart';
import 'package:partners/core/injection/home/home_injection.dart';
import 'package:partners/core/injection/pagar/pagar_injection.dart';
import 'package:partners/core/injection/para_ti/para_ti_injection.dart';
import 'package:partners/core/injection/productos/productos_injection.dart';
import 'package:partners/core/injection/promos/promos_injection.dart';
import 'package:partners/core/injection/role_injection.dart';
import 'package:partners/core/injection/transactions/transactions_injection.dart';
import 'package:partners/core/injection/users/users_injection.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/managers/auth/auth_manager_impl.dart';
import 'package:partners/core/managers/auth/storage/token_manager.dart';
import 'package:partners/core/routes/app_routes.dart';
import 'package:partners/core/services/database/flags/flags_factory.dart';
import 'package:partners/core/services/database/flags/session_id_storage.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/services/network/dio_services_impl.dart';
import 'package:partners/core/services/location/location_service.dart';
import 'package:partners/core/services/location/location_service_impl.dart';
import 'package:partners/core/services/mapbox/mapbox_geocoding_service.dart';
import 'package:partners/core/services/ocr/ocr_service.dart';
import 'package:partners/core/services/ocr/realtime_ocr_service.dart';

class AppInjection {
  final GetIt _getIt;
  final String _baseUrl;

  AppInjection({required GetIt getIt, required String baseUrl})
    : _getIt = getIt,
      _baseUrl = baseUrl {
    _init();
  }

  void _init() {
    // Auth Managers
    if (!_getIt.isRegistered<TokenManager>()) {
      _getIt.registerLazySingleton<TokenManager>(() => TokenManager());
    }

    if (!_getIt.isRegistered<AuthManager>()) {
      _getIt.registerLazySingleton<AuthManager>(
        () => AuthManagerImpl(_getIt<TokenManager>()),
      );
    }

    if (!_getIt.isRegistered<SessionIdStorage>()) {
      _getIt.registerLazySingleton<SessionIdStorage>(
        () => FlagsFactory.createSessionIdFlug(),
      );
    }

    if (!_getIt.isRegistered<OcrService>()) {
      _getIt.registerLazySingleton<OcrService>(() => OcrService());
    }
    if (!_getIt.isRegistered<RealtimeOcrService>()) {
      _getIt.registerLazySingleton<RealtimeOcrService>(
        () => RealtimeOcrService(),
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
    if (!_getIt.isRegistered<AppRouter>()) {
      _getIt.registerLazySingleton<AppRouter>(() => AppRouter());
    }
    if (!_getIt.isRegistered<LocationService>()) {
      _getIt.registerLazySingleton<LocationService>(
        () => LocationServiceImpl(),
      );
    }
    if (!_getIt.isRegistered<MapboxGeocodingService>()) {
      _getIt.registerLazySingleton<MapboxGeocodingService>(
        () => MapboxGeocodingServiceImpl(),
      );
    }

    AuthInjection(getIt: _getIt);
    ValidationInjeciton(getIt: _getIt);
    DocumentInjection(getIt: _getIt);
    RoleInjection(getIt: _getIt);
    ProductosInjection(getIt: _getIt);
    PagarInjection(getIt: _getIt);
    ParaTiInjection(getIt: _getIt);
    HomeInjection(getIt: _getIt);
    BranchesInjection(getIt: _getIt);
    TransactionsInjection(getIt: _getIt);
    PromosInjection(getIt: _getIt);
    UsersInjection(getIt: _getIt);
  }
}
