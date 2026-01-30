import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:partners/app.dart';
import 'package:partners/core/config/app_config.dart';
import 'package:partners/core/injection/app_injection.dart';
import 'package:partners/core/managers/shared_preferences_manager.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.initialize();
  AppInjection(getIt: getIt, baseUrl: AppConfig.baseUrl);
  runApp(const App());
}
