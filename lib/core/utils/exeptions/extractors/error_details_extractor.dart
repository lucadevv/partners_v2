class ErrorDetailsExtractor {
  static String? extract(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['details'] ?? data['description'];
    }
    return null;
  }
}
