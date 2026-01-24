import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:partners/app.dart';
import 'package:partners/core/config/app_config.dart';
import 'package:partners/core/injection/app_injection.dart';
import 'package:partners/core/utils/logger/app_logger.dart';

final GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    AppLogger.error(
      'Flutter Error',
      details.exception,
      details.stack,
      'FlutterError',
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error(
      'Platform Error',
      error,
      stack,
      'PlatformDispatcher',
    );
    return true;
  };

  try {
    AppInjection(getIt: getIt, baseUrl: AppConfig.baseUrl);
  } catch (e, stackTrace) {
    AppLogger.error(
      'Error al inicializar la aplicación',
      e,
      stackTrace,
      'AppInjection',
    );
  }

  runApp(const App());
}
