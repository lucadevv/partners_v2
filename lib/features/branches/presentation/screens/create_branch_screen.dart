import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/services/location/location_service.dart';
import 'package:partners/core/services/mapbox/mapbox_geocoding_service.dart';
import 'package:partners/features/branches/presentation/cubit/create_branch_cubit.dart';
import 'package:partners/features/branches/presentation/cubit/create_branch_state.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';
import 'package:partners/features/branches/presentation/widgets/category_bottom_sheet.dart';
import 'package:partners/features/branches/presentation/widgets/create_branch_address_map_section.dart';
import 'package:partners/features/branches/presentation/widgets/create_branch_address_search_helper.dart';
import 'package:partners/main.dart';
import 'package:partners/features/branches/presentation/widgets/create_branch_create_button.dart';
import 'package:partners/features/branches/presentation/widgets/create_branch_form_body.dart';
import 'package:partners/features/branches/presentation/widgets/create_branch_image_picker_handler.dart';
import 'package:partners/features/branches/presentation/widgets/create_branch_image_source_modal.dart';
import 'package:partners/features/branches/presentation/widgets/create_branch_screen_app_bar.dart';
import 'package:partners/features/branches/presentation/widgets/schedule_bottom_sheet.dart';
import 'package:partners/features/branches/presentation/widgets/subcategory_bottom_sheet.dart';

@RoutePage()
class CreateBranchScreen extends StatefulWidget implements AutoRouteWrapper {
  const CreateBranchScreen({super.key});

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<CreateBranchCubit>(
      create: (_) => getIt<CreateBranchCubit>(),
      child: this,
    );
  }
}

/// Origen de la ubicación seleccionada. Prioridad: mapTap > search > gps.
enum _LocationSource { mapTap, search, gps }

class _CreateBranchScreenState extends State<CreateBranchScreen> {
  late CreateBranchFormNotifier _formNotifier;
  CreateBranchAddressSearchHelper? _addressSearchHelper;
  final ValueNotifier<bool> _mapInteractionNotifier = ValueNotifier<bool>(
    false,
  );
  static const double _defaultLng = -77.0428;
  static const double _defaultLat = -12.0464;
  static const double _defaultZoom = 14.0;
  static const double _zoomWhenLocated = 16.0;
  double _mapCenterLng = _defaultLng;
  double _mapCenterLat = _defaultLat;
  double? _markerLng;
  double? _markerLat;
  double _mapZoom = _defaultZoom;
  _LocationSource? _lastLocationSource;

  void _onLocationFound(double lng, double lat, _LocationSource source) {
    if (!mounted) return;
    _formNotifier.setLatLng(lat, lng);
    setState(() {
      _mapCenterLng = lng;
      _mapCenterLat = lat;
      _markerLng = lng;
      _markerLat = lat;
      _mapZoom = _zoomWhenLocated;
      _lastLocationSource = source;
    });
  }

  Future<void> _goToMyLocation() async {
    if (_lastLocationSource == _LocationSource.mapTap ||
        _lastLocationSource == _LocationSource.search) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(CreateBranchScreenStrings.locationPriorityMessage),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }
    final result = await getIt<LocationService>()
        .requestPermissionAndGetCurrentPosition();
    if (!mounted) return;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(CreateBranchScreenStrings.locationDisabledMessage),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }
    final lng = result.longitude;
    final lat = result.latitude;
    _onLocationFound(lng, lat, _LocationSource.gps);
    final display = await getIt<MapboxGeocodingService>().reverseGeocode(
      lng,
      lat,
    );
    if (!mounted) return;
    if (display != null) {
      _formNotifier.addressController.text = display.displayName;
      _formNotifier.addressController.selection = TextSelection.fromPosition(
        TextPosition(offset: display.displayName.length),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _formNotifier = CreateBranchFormNotifier();
    _addressSearchHelper = CreateBranchAddressSearchHelper(
      formNotifier: _formNotifier,
      geocodingService: getIt<MapboxGeocodingService>(),
      onLocationFound: (lng, lat) {
        if (!mounted) return;
        // Prioridad: no sobrescribir con búsqueda si el usuario eligió en el mapa (tap/long press).
        if (_lastLocationSource == _LocationSource.mapTap) return;
        _onLocationFound(lng, lat, _LocationSource.search);
      },
    );
    _addressSearchHelper!.start();
  }

  @override
  void dispose() {
    _mapInteractionNotifier.dispose();
    _addressSearchHelper?.dispose();
    _formNotifier.dispose();
    super.dispose();
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryBottomSheetContent(
        formNotifier: _formNotifier,
        onSelect: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showSubCategoryBottomSheet() {
    if (_formNotifier.selectedCategoryEntity == null) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SubcategoryBottomSheetContent(
        categoryId: _formNotifier.selectedCategoryEntity!.id,
        formNotifier: _formNotifier,
        onSelect: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showScheduleBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          ScheduleBottomSheetContent(formNotifier: _formNotifier),
    );
  }

  void _showImageSourceBottomSheet() {
    final screenContext = context;
    showModalBottomSheet(
      context: screenContext,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => CreateBranchImageSourceModal(
        onTakePhoto: () {
          Navigator.pop(modalContext);
          CreateBranchImagePickerHandler.pickFromCamera(
            screenContext,
            _formNotifier,
          );
        },
        onUploadFromGallery: () {
          Navigator.pop(modalContext);
          CreateBranchImagePickerHandler.pickFromGallery(
            screenContext,
            _formNotifier,
          );
        },
      ),
    );
  }

  void _onMapTapped(double lng, double lat) {
    _formNotifier.setLatLng(lat, lng);
    CreateBranchMapCallbacks.onMapTapped(
      context,
      lng,
      lat,
      _formNotifier,
      (lng, lat) => setState(() {
        _mapCenterLng = lng;
        _mapCenterLat = lat;
        _markerLng = lng;
        _markerLat = lat;
        _mapZoom = _zoomWhenLocated;
        _lastLocationSource = _LocationSource.mapTap;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateBranchCubit, CreateBranchState>(
      listener: (context, state) {
        if (state.status == CreateBranchStatus.success) {
          final message =
              state.successMessage ??
              CreateBranchScreenStrings.createSuccessMessage;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          _formNotifier.reset();
          setState(() {
            _mapCenterLng = _defaultLng;
            _mapCenterLat = _defaultLat;
            _markerLng = null;
            _markerLat = null;
            _mapZoom = _defaultZoom;
            _lastLocationSource = null;
          });
          context.read<CreateBranchCubit>().reset();
        }
        if (state.status == CreateBranchStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CreateBranchScreenAppBar(),
        body: ListenableBuilder(
          listenable: _formNotifier,
          builder: (context, _) => Stack(
            children: [
              ListenableBuilder(
                listenable: _mapInteractionNotifier,
                builder: (context, _) {
                  final blockScroll = _mapInteractionNotifier.value;
                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      physics: blockScroll
                          ? const NeverScrollableScrollPhysics()
                          : null,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CreateBranchFormBody(
                        formNotifier: _formNotifier,
                        mapCenterLng: _mapCenterLng,
                        mapCenterLat: _mapCenterLat,
                        markerLng: _markerLng,
                        markerLat: _markerLat,
                        mapZoom: _mapZoom,
                        onShowCategory: _showCategoryBottomSheet,
                        onShowSubcategory: _showSubCategoryBottomSheet,
                        onShowSchedule: _showScheduleBottomSheet,
                        onShowImageSource: _showImageSourceBottomSheet,
                        onMapTapped: _onMapTapped,
                        onMapCreated: (_) {},
                        mapInteractionNotifier: _mapInteractionNotifier,
                        onMyLocationRequested: _goToMyLocation,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 0,
                child: SafeArea(
                  child: BlocBuilder<CreateBranchCubit, CreateBranchState>(
                    buildWhen: (prev, curr) => prev.status != curr.status,
                    builder: (context, state) => CreateBranchCreateButton(
                      formNotifier: _formNotifier,
                      onPressed: state.status == CreateBranchStatus.loading
                          ? null
                          : () => context
                                .read<CreateBranchCubit>()
                                .createBranch(_formNotifier),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
