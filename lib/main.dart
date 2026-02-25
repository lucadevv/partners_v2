import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:partners/app.dart';
import 'package:partners/core/config/app_config.dart';
import 'package:partners/core/injection/app_injection.dart';
import 'package:partners/core/managers/shared_preferences_manager.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(() async {
    try {
      final mapboxToken = AppConfig.tokenMapbox;
      if (mapboxToken.isNotEmpty) {
        MapboxOptions.setAccessToken(mapboxToken);
      }
      await SharedPreferencesManager.initialize();
      AppInjection(getIt: getIt, baseUrl: AppConfig.baseUrl);
      runApp(const App());
    } catch (e, stackTrace) {
      runApp(_ErrorApp(error: e, stackTrace: stackTrace));
    }
  }, (error, stackTrace) {
    FlutterError.presentError(
      FlutterErrorDetails(exception: error, stack: stackTrace),
    );
  });
}

/// App mínima mostrada si el arranque falla (evita quedarse en splash nativo).
class _ErrorApp extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;

  const _ErrorApp({required this.error, this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Error al iniciar la aplicación',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text('$error', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
