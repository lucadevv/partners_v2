import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/services/services.dart';
import 'package:partners/features/users/domain/domain.dart';
import 'package:partners/main.dart';

@RoutePage()
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  static const double _defaultLng = -77.0428;
  static const double _defaultLat = -12.0464;
  static const double _radiusKm = 3.0;

  late double _effectiveLng;
  late double _effectiveLat;
  List<UserLocationEntity> _users = const [];
  bool _usersLoaded = false;
  MapboxMap? _mapboxMap;

  @override
  void initState() {
    super.initState();
    _effectiveLng = _defaultLng;
    _effectiveLat = _defaultLat;
    _requestLocationAndCenter();
    _loadUsersInRadius();
  }

  Future<void> _requestLocationAndCenter() async {
    final result = await getIt<LocationService>()
        .requestPermissionAndGetCurrentPosition();
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _effectiveLat = result.latitude;
        _effectiveLng = result.longitude;
        _usersLoaded = false;
      });
      _loadUsersInRadius();
    }
  }

  Future<void> _loadUsersInRadius() async {
    final result = await getIt<GetUsersInRadiusUsecase>().call(
      centerLat: _effectiveLat,
      centerLng: _effectiveLng,
      radiusKm: _radiusKm,
    );
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _users = [];
        _usersLoaded = true;
      }),
      (list) => setState(() {
        _users = list;
        _usersLoaded = true;
      }),
    );
  }

  Future<void> _hideMapboxLegend(MapboxMap? map) async {
    if (map == null) return;
    try {
      await map.attribution.updateSettings(AttributionSettings(enabled: false));
      await map.logo.updateSettings(LogoSettings(enabled: false));
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

  void _onMapLoadedListener(MapLoadedEventData data) {
    _hideMapboxLegend(_mapboxMap);
    _scheduleHideMapboxLegend();
  }

  List<Position> _circlePolygon(double lng, double lat, double radiusKm) {
    const int points = 64;
    final double latRad = lat * math.pi / 180;
    final double dLat = radiusKm / 111.0;
    final double dLng = radiusKm / (111.0 * math.cos(latRad));
    final List<Position> ring = [];
    for (var i = 0; i <= points; i++) {
      final angle = 2 * math.pi * i / points;
      ring.add(
        Position(lng + dLng * math.sin(angle), lat + dLat * math.cos(angle)),
      );
    }
    return ring;
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    _hideMapboxLegend(mapboxMap);
    _scheduleHideMapboxLegend();

    final ring = _circlePolygon(_effectiveLng, _effectiveLat, _radiusKm);
    final polygonManager = await mapboxMap.annotations
        .createPolygonAnnotationManager();
    polygonManager.create(
      PolygonAnnotationOptions(
        geometry: Polygon(coordinates: [ring]),
        fillColor: 0x5566CFFF,
        fillOpacity: 0.55,
        fillOutlineColor: 0xFF66CFFF,
      ),
    );
    final polylineManager = await mapboxMap.annotations
        .createPolylineAnnotationManager();
    polylineManager.create(
      PolylineAnnotationOptions(
        geometry: LineString(coordinates: ring),
        lineColor: 0xFF0EA5E9,
        lineWidth: 3.0,
        lineOpacity: 1.0,
      ),
    );

    final circleManager = await mapboxMap.annotations
        .createCircleAnnotationManager();
    const blue = 0xFF0EA5E9;
    const magenta = 0xFFFF0AC2;
    final options = <CircleAnnotationOptions>[];
    for (var i = 0; i < _users.length; i++) {
      final u = _users[i];
      options.add(
        CircleAnnotationOptions(
          geometry: Point(
            coordinates: Position(u.longitude, u.latitude),
          ),
          circleColor: i.isEven ? blue : magenta,
          circleRadius: 11.0,
        ),
      );
    }
    if (options.isNotEmpty) {
      circleManager.createMulti(options);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraOptions = CameraOptions(
      center: Point(coordinates: Position(_effectiveLng, _effectiveLat)),
      zoom: 12,
      bearing: 0,
      pitch: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Users',
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!_usersLoaded)
            Center(
              child: CircularProgressIndicator(color: context.appColor.primary),
            )
          else
            MapWidget(
              key: ValueKey('users_map_${_effectiveLat}_$_effectiveLng'),
              cameraOptions: cameraOptions,
              styleUri: MapboxStyles.MAPBOX_STREETS,
              onMapCreated: _onMapCreated,
              onMapLoadedListener: _onMapLoadedListener,
            ),
          Positioned(
            right: 16,
            top: kToolbarHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.appColor.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.appColor.primary),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  'Radio: 3 km',
                  style: TextStyle(
                    color: context.appColor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.appColor.secondary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _requestLocationAndCenter,
                      borderRadius: BorderRadius.circular(50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.my_location,
                            color: context.appColor.primary,
                            size: 22,
                          ),
                          10.spacew,
                          Text(
                            'Actualizar ubicación',
                            style: TextStyle(
                              color: context.appColor.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
