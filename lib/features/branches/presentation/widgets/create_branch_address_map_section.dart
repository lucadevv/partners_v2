import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/services/mapbox/mapbox_geocoding_service.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/main.dart';

/// Sección dirección + mapa: campo de texto, tap/long press para colocar
/// marcador y geocodificar inverso. Botón "mi ubicación" (abajo derecha).
/// Leyenda Mapbox oculta; gestos explícitos para poder pan/zoom dentro del scroll.
class CreateBranchAddressMapSection extends StatefulWidget {
  final CreateBranchFormNotifier formNotifier;
  final double mapCenterLng;
  final double mapCenterLat;
  final double? markerLng;
  final double? markerLat;
  final double mapZoom;
  final void Function(double lng, double lat) onMapTapped;
  final void Function(MapboxMap mapboxMap)? onMapCreated;

  /// Cuando el usuario arrastra en el mapa, se pone a true para desactivar scroll del padre.
  final ValueNotifier<bool>? mapInteractionNotifier;

  /// Al pulsar el botón de "mi ubicación": solicitar permiso y centrar en GPS.
  final VoidCallback? onMyLocationRequested;

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
    this.onMapCreated,
    this.mapInteractionNotifier,
    this.onMyLocationRequested,
  });

  @override
  State<CreateBranchAddressMapSection> createState() =>
      _CreateBranchAddressMapSectionState();
}

class _CreateBranchAddressMapSectionState
    extends State<CreateBranchAddressMapSection> {
  MapboxMap? _mapboxMap;
  CircleAnnotationManager? _circleManager;

  /// Gestos que debe consumir el mapa para poder pan/zoom dentro de un ScrollView.
  static Set<Factory<OneSequenceGestureRecognizer>> get _gestureRecognizers =>
      <Factory<OneSequenceGestureRecognizer>>{
        Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
        Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
        Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
      };

  Future<void> _hideMapboxLegend(MapboxMap? map) async {
    if (map == null) return;
    try {
      await map.attribution.updateSettings(AttributionSettings(enabled: false));
      await map.logo.updateSettings(LogoSettings(enabled: false));
      await map.compass.updateSettings(CompassSettings(enabled: false));
    } catch (_) {}
  }

  void _scheduleHideMapboxLegend() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _hideMapboxLegend(_mapboxMap);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _hideMapboxLegend(_mapboxMap);
    });
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _hideMapboxLegend(mapboxMap);
    _scheduleHideMapboxLegend();

    try {
      _circleManager = await mapboxMap.annotations
          .createCircleAnnotationManager();
      await _updateMarkerPosition();
    } catch (_) {}
    widget.onMapCreated?.call(mapboxMap);
  }

  /// Dibuja el marcador de ubicación (mismo estilo que users_screen: círculo azul).
  Future<void> _updateMarkerPosition() async {
    final lng = widget.markerLng;
    final lat = widget.markerLat;
    final manager = _circleManager;
    if (manager == null || lng == null || lat == null) return;
    await manager.deleteAll();
    if (!mounted) return;
    manager.create(
      CircleAnnotationOptions(
        geometry: Point(coordinates: Position(lng, lat)),
        circleColor: 0xFF0EA5E9,
        circleRadius: 10.0,
        circleStrokeColor: 0xFFFFFFFF,
        circleStrokeWidth: 2.0,
      ),
    );
  }

  void _onMapLoaded(MapLoadedEventData _) {
    _hideMapboxLegend(_mapboxMap);
    _scheduleHideMapboxLegend();
    _updateMarkerPosition();
  }

  void _flyToCenter() {
    final map = _mapboxMap;
    if (map == null) return;
    try {
      map.flyTo(
        CameraOptions(
          center: Point(
            coordinates: Position(widget.mapCenterLng, widget.mapCenterLat),
          ),
          zoom: widget.mapZoom,
        ),
        MapAnimationOptions(duration: 500, startDelay: 0),
      );
    } catch (_) {}
  }

  void _resetBearingToNorth() {
    final map = _mapboxMap;
    if (map == null) return;
    try {
      map.flyTo(
        CameraOptions(
          center: Point(
            coordinates: Position(widget.mapCenterLng, widget.mapCenterLat),
          ),
          zoom: widget.mapZoom,
          bearing: 0,
        ),
        MapAnimationOptions(duration: 300, startDelay: 0),
      );
    } catch (_) {}
  }

  @override
  void didUpdateWidget(covariant CreateBranchAddressMapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.markerLng != widget.markerLng ||
        oldWidget.markerLat != widget.markerLat) {
      _updateMarkerPosition();
    }
    if (oldWidget.mapCenterLng != widget.mapCenterLng ||
        oldWidget.mapCenterLat != widget.mapCenterLat ||
        oldWidget.mapZoom != widget.mapZoom) {
      _flyToCenter();
    }
  }

  void _onPointerMove(_) {
    widget.mapInteractionNotifier?.value = true;
  }

  void _onPointerUp(_) {
    widget.mapInteractionNotifier?.value = false;
  }

  void _onPointerCancel(_) {
    widget.mapInteractionNotifier?.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.spaceh,
        Text(
          widget.formNotifier.addressField.label,
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
              Listener(
                onPointerMove: _onPointerMove,
                onPointerUp: _onPointerUp,
                onPointerCancel: _onPointerCancel,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MapWidget(
                    key: CreateBranchAddressMapSection.mapKey,
                    cameraOptions: CameraOptions(
                      center: Point(
                        coordinates: Position(
                          widget.mapCenterLng,
                          widget.mapCenterLat,
                        ),
                      ),
                      zoom: widget.mapZoom,
                    ),
                    styleUri: MapboxStyles.MAPBOX_STREETS,
                    gestureRecognizers: _gestureRecognizers,
                    onMapCreated: _onMapCreated,
                    onTapListener: (MapContentGestureContext ctx) {
                      final lng = ctx.point.coordinates.lng.toDouble();
                      final lat = ctx.point.coordinates.lat.toDouble();
                      widget.onMapTapped(lng, lat);
                    },
                    onLongTapListener: (MapContentGestureContext ctx) {
                      final lng = ctx.point.coordinates.lng.toDouble();
                      final lat = ctx.point.coordinates.lat.toDouble();
                      widget.onMapTapped(lng, lat);
                    },
                    onMapLoadedListener: _onMapLoaded,
                  ),
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
                      controller: widget.formNotifier.addressController,
                      style: TextStyle(
                        color: context.appColor.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Figtree',
                      ),
                      decoration: InputDecoration(
                        hintText: widget.formNotifier.addressField.placeholder,
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
                        errorText: widget.formNotifier.addressError,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(24),
                      color: context.appColor.surface.withValues(alpha: 0.95),
                      child: InkWell(
                        onTap: _resetBearingToNorth,
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.explore,
                            color: context.appColor.primary,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    if (widget.onMyLocationRequested != null) ...[
                      const SizedBox(height: 8),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(24),
                        color: context.appColor.surface.withValues(alpha: 0.95),
                        child: InkWell(
                          onTap: widget.onMyLocationRequested,
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.my_location,
                              color: context.appColor.primary,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Helpers para callbacks del mapa (geocodificar inverso).
class CreateBranchMapCallbacks {
  CreateBranchMapCallbacks._();

  /// Al tocar o hacer long press en el mapa: geocodificación inversa y
  /// actualiza el TextField de dirección; siempre mueve el marcador.
  static Future<void> onMapTapped(
    BuildContext context,
    double lng,
    double lat,
    CreateBranchFormNotifier formNotifier,
    void Function(double lng, double lat) onLocationSelected,
  ) async {
    final result = await getIt<MapboxGeocodingService>().reverseGeocode(
      lng,
      lat,
    );
    if (!context.mounted) return;
    if (result != null) {
      formNotifier.addressController.text = result.displayName;
      formNotifier.addressController.selection = TextSelection.fromPosition(
        TextPosition(offset: result.displayName.length),
      );
    }
    onLocationSelected(lng, lat);
  }
}
