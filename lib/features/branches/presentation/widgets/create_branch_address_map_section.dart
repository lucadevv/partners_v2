import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/services/mapbox/mapbox_geocoding_service.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/main.dart';

/// Sección dirección + mapa: campo de texto sobre el mapa, tap para geocodificar inverso.
class CreateBranchAddressMapSection extends StatelessWidget {
  final CreateBranchFormNotifier formNotifier;
  final double mapCenterLng;
  final double mapCenterLat;
  final double? markerLng;
  final double? markerLat;
  final double mapZoom;
  final void Function(double lng, double lat) onMapTapped;
  final void Function(MapboxMap mapboxMap) onMapCreated;

  static const Key mapKey = ValueKey<String>('create_branch_map');

  const CreateBranchAddressMapSection({
    super.key,
    required this.formNotifier,
    required this.mapCenterLng,
    required this.mapCenterLat,
    this.markerLng,
    this.markerLat,
    required this.mapZoom,
    required this.onMapTapped,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.spaceh,
        Text(
          formNotifier.addressField.label,
          style: TextStyle(
            color: context.appColor.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Figtree',
          ),
        ),
        8.spaceh,
        SizedBox(
          height: 321,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MapWidget(
                  key: mapKey,
                  cameraOptions: CameraOptions(
                    center: Point(
                      coordinates: Position(mapCenterLng, mapCenterLat),
                    ),
                    zoom: mapZoom,
                  ),
                  styleUri: MapboxStyles.MAPBOX_STREETS,
                  onMapCreated: onMapCreated,
                  onTapListener: (MapContentGestureContext ctx) {
                    final lng = ctx.point.coordinates.lng.toDouble();
                    final lat = ctx.point.coordinates.lat.toDouble();
                    onMapTapped(lng, lat);
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      controller: formNotifier.addressController,
                      style: TextStyle(
                        color: context.appColor.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Figtree',
                      ),
                      decoration: InputDecoration(
                        hintText: formNotifier.addressField.placeholder,
                        hintStyle: TextStyle(
                          color: context.appColor.primary,
                          fontSize: 16,
                          fontFamily: 'Figtree',
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        errorText: formNotifier.addressError,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Helpers para callbacks del mapa (geocodificar inverso y círculo en mapa).
class CreateBranchMapCallbacks {
  CreateBranchMapCallbacks._();

  static Future<void> onMapCreated(
    MapboxMap mapboxMap,
    double? markerLng,
    double? markerLat,
  ) async {
    if (markerLng == null || markerLat == null) return;
    try {
      final circleManager =
          await mapboxMap.annotations.createCircleAnnotationManager();
      circleManager.create(
        CircleAnnotationOptions(
          geometry: Point(coordinates: Position(markerLng, markerLat)),
          circleColor: 0xFF0EA5E9,
          circleRadius: 12.0,
        ),
      );
    } catch (_) {}
  }

  static Future<void> onMapTapped(
    BuildContext context,
    double lng,
    double lat,
    CreateBranchFormNotifier formNotifier,
    void Function(double lng, double lat) onLocationSelected,
  ) async {
    final result = await getIt<MapboxGeocodingService>().reverseGeocode(lng, lat);
    if (!context.mounted) return;
    if (result != null) {
      formNotifier.addressController.text = result.displayName;
      formNotifier.addressController.selection = TextSelection.fromPosition(
        TextPosition(offset: result.displayName.length),
      );
      onLocationSelected(lng, lat);
    }
  }
}
