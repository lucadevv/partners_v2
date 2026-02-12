import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location_service.dart';

/// Implementación que usa [permission_handler] para permisos y [geolocator] para la posición.
class LocationServiceImpl implements LocationService {
  @override
  Future<LocationResult?> requestPermissionAndGetCurrentPosition() async {
    final status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      return null;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested != LocationPermission.whileInUse &&
          requested != LocationPermission.always) {
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );
    return LocationResult(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
