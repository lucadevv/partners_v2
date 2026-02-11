class AppConfig {
  static const String baseUrl = String.fromEnvironment('base_url');
  static const String tokenMapbox = String.fromEnvironment('token_mapbox');

  static String getValidatedTokenMapbox() {
    if (tokenMapbox.isEmpty) {
      throw Exception(
        'token_mapbox no está configurada. Use --dart-define=token_mapbox=...',
      );
    }
    return tokenMapbox;
  }

  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
  static const int httpTimeout = 10;
  static const String defaultLanguage = 'es-ES';

  static String getValidatedBaseUrl() {
    if (baseUrl.isEmpty) {
      throw Exception(
        'base_url no está configurada. Use --dart-define=base_url=...',
      );
    }
    return baseUrl;
  }
}
