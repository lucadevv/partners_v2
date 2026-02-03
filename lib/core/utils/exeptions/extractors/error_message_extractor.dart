class ErrorMessageExtractor {
  static String extract(dynamic data, String defaultMessage) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? defaultMessage;
    }
    return defaultMessage;
  }
}
