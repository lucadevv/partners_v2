import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferencesManager? _instance;
  static SharedPreferences? _prefs;

  SharedPreferencesManager._internal();

  factory SharedPreferencesManager() {
    return _instance ??= SharedPreferencesManager._internal();
  }

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception(
        'SharedPreferences no inicializado. '
        'Llama a SharedPreferencesManager.initialize() en main()',
      );
    }
    return _prefs!;
  }

  static SharedPreferences get I => instance;
}
