import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:partners/app.dart';
import 'package:partners/core/config/app_config.dart';
import 'package:partners/core/injection/app_injection.dart';

final GetIt getIt = GetIt.instance;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppInjection(getIt: getIt, baseUrl: AppConfig.baseUrl);
  runApp(const App());
}
