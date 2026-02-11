import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:partners/core/config/app_config.dart';

/// Resultado de una búsqueda de dirección (Mapbox Geocoding API).
class GeocodingResult {
  final double longitude;
  final double latitude;
  final String displayName;

  const GeocodingResult({
    required this.longitude,
    required this.latitude,
    required this.displayName,
  });
}

/// Servicio para buscar direcciones con Mapbox Geocoding API.
/// Usar con debouncer en el campo de dirección (ej. 400–500 ms).
abstract class MapboxGeocodingService {
  Future<GeocodingResult?> searchAddress(String query);

  /// Geocodificación inversa: coordenadas → dirección (para tap en el mapa).
  Future<GeocodingResult?> reverseGeocode(double longitude, double latitude);
}

class MapboxGeocodingServiceImpl implements MapboxGeocodingService {
  MapboxGeocodingServiceImpl({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const String _baseUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';

  @override
  Future<GeocodingResult?> searchAddress(String query) async {
    if (query.trim().isEmpty) return null;
    final token = _getToken();
    if (token == null || token.isEmpty) return null;

    try {
      final encoded = Uri.encodeComponent(query.trim());
      // Restringir a Perú, solo direcciones y mejor resultado
      const country = 'PE';
      const language = 'es';
      const types = 'address';
      final url = '$_baseUrl/$encoded.json?access_token=$token&limit=1&country=$country&language=$language&types=$types';
      final response = await _dio.get<String>(url);
      if (response.data == null) return null;

      final json = jsonDecode(response.data!) as Map<String, dynamic>;
      final features = json['features'] as List<dynamic>?;
      if (features == null || features.isEmpty) return null;

      final feature = features.first as Map<String, dynamic>;
      final geometry = feature['geometry'] as Map<String, dynamic>?;
      final coordinates = geometry?['coordinates'] as List<dynamic>?;
      final placeName = feature['place_name'] as String? ?? '';

      if (coordinates == null || coordinates.length < 2) return null;

      final lng = (coordinates[0] as num).toDouble();
      final lat = (coordinates[1] as num).toDouble();

      return GeocodingResult(
        longitude: lng,
        latitude: lat,
        displayName: placeName,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<GeocodingResult?> reverseGeocode(double longitude, double latitude) async {
    final token = _getToken();
    if (token == null || token.isEmpty) return null;

    try {
      // Mapbox reverse: /mapbox.places/{longitude},{latitude}.json
      const country = 'PE';
      const language = 'es';
      final url = '$_baseUrl/$longitude,$latitude.json?access_token=$token&limit=1&country=$country&language=$language';
      final response = await _dio.get<String>(url);
      if (response.data == null) return null;

      final json = jsonDecode(response.data!) as Map<String, dynamic>;
      final features = json['features'] as List<dynamic>?;
      if (features == null || features.isEmpty) return null;

      final feature = features.first as Map<String, dynamic>;
      final placeName = feature['place_name'] as String? ?? '';

      return GeocodingResult(
        longitude: longitude,
        latitude: latitude,
        displayName: placeName,
      );
    } catch (_) {
      return null;
    }
  }

  String? _getToken() {
    try {
      return AppConfig.getValidatedTokenMapbox();
    } catch (_) {
      return null;
    }
  }
}
