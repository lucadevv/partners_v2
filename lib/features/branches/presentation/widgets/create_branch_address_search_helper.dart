import 'dart:async';

import 'package:partners/core/services/mapbox/mapbox_geocoding_service.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';

/// Helper que encapsula búsqueda de dirección con debounce y geocodificación.
/// La pantalla registra el listener en initState y llama [dispose] en dispose.
class CreateBranchAddressSearchHelper {
  CreateBranchAddressSearchHelper({
    required CreateBranchFormNotifier formNotifier,
    required MapboxGeocodingService geocodingService,
    required void Function(double lng, double lat) onLocationFound,
  })  : _formNotifier = formNotifier,
        _geocodingService = geocodingService,
        _onLocationFound = onLocationFound;

  final CreateBranchFormNotifier _formNotifier;
  final MapboxGeocodingService _geocodingService;
  final void Function(double lng, double lat) _onLocationFound;

  Timer? _debounce;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  void start() {
    _formNotifier.addressController.addListener(_onAddressChanged);
  }

  void dispose() {
    _debounce?.cancel();
    _formNotifier.addressController.removeListener(_onAddressChanged);
  }

  void _onAddressChanged() {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, _searchAddressAndNotify);
  }

  Future<void> _searchAddressAndNotify() async {
    final query = _formNotifier.addressController.text.trim();
    if (query.isEmpty) return;
    final result = await _geocodingService.searchAddress(query);
    if (result != null) {
      _onLocationFound(result.longitude, result.latitude);
    }
  }
}
