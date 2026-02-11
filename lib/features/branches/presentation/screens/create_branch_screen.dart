import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/services/mapbox/mapbox_geocoding_service.dart';
import 'package:partners/core/widgets/custom_text_form_field.dart';
import 'package:partners/features/branches/presentation/presentation.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';
import 'package:partners/main.dart';

@RoutePage()
class CreateBranchScreen extends StatefulWidget {
  const CreateBranchScreen({super.key});

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();
}

class _CreateBranchScreenState extends State<CreateBranchScreen> {
  late CreateBranchFormNotifier _formNotifier;
  Timer? _addressSearchDebounce;
  double _mapCenterLng = _defaultLng;
  double _mapCenterLat = _defaultLat;

  @override
  void initState() {
    super.initState();
    _formNotifier = CreateBranchFormNotifier();
    _formNotifier.addressController.addListener(_onAddressChangedForSearch);
  }

  void _onAddressChangedForSearch() {
    _addressSearchDebounce?.cancel();
    _addressSearchDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchAddressAndUpdateMap();
    });
  }

  Future<void> _searchAddressAndUpdateMap() async {
    final query = _formNotifier.addressController.text.trim();
    if (query.isEmpty) return;
    final service = getIt<MapboxGeocodingService>();
    final result = await service.searchAddress(query);
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _mapCenterLng = result.longitude;
        _mapCenterLat = result.latitude;
      });
    }
  }

  @override
  void dispose() {
    _addressSearchDebounce?.cancel();
    _formNotifier.addressController.removeListener(_onAddressChangedForSearch);
    _formNotifier.dispose();
    super.dispose();
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.appColor.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const SizedBox(width: 131, height: 5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  CreateBranchScreenStrings.chooseCategoryTitle,
                  style: TextStyle(
                    color: context.appColor.primary,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: CreateBranchScreenStrings.categories.length,
                itemBuilder: (context, index) {
                  final category = CreateBranchScreenStrings.categories[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _formNotifier.setCategory(category);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.appColor.onSurface,
                                  width: 1,
                                ),
                              ),
                              child: const SizedBox(width: 24, height: 24),
                            ),
                            const SizedBox(width: 30),
                            Text(
                              category,
                              style: TextStyle(
                                color: context.appColor.onSurface,
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubCategoryBottomSheet() {
    if (_formNotifier.selectedCategory == null) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.appColor.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const SizedBox(width: 131, height: 5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  CreateBranchScreenStrings.chooseSubCategoryTitle,
                  style: TextStyle(
                    color: context.appColor.primary,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: CreateBranchScreenStrings.subCategories.length,
                itemBuilder: (context, index) {
                  final subCategory =
                      CreateBranchScreenStrings.subCategories[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _formNotifier.setSubCategory(subCategory);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.appColor.onSurface,
                                  width: 1,
                                ),
                              ),
                              child: const SizedBox(width: 24, height: 24),
                            ),
                            const SizedBox(width: 30),
                            Text(
                              subCategory,
                              style: TextStyle(
                                color: context.appColor.onSurface,
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showScheduleBottomSheet() {
    final selectedDays = <String>{
      ...CreateBranchScreenStrings.scheduleModalDays,
    };
    String startTime = '09:00';
    String endTime = '21:00';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: context.appColor.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const SizedBox(width: 131, height: 5),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          CreateBranchScreenStrings.scheduleModalTitle,
                          style: TextStyle(
                            color: context.appColor.primary,
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          CreateBranchScreenStrings.scheduleModalDaysLabel,
                          style: TextStyle(
                            color: context.appColor.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ),
                      20.spaceh,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Wrap(
                          spacing: 18,
                          runSpacing: 18,
                          children: CreateBranchScreenStrings.scheduleModalDays
                              .map((day) {
                                final isSelected = selectedDays.contains(day);
                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      if (isSelected) {
                                        selectedDays.remove(day);
                                      } else {
                                        selectedDays.add(day);
                                      }
                                    });
                                  },
                                  child: SizedBox(
                                    width: 86,
                                    height: 86,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? context.appColor.primary
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? context.appColor.primary
                                              : context.appColor.primary,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          day,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : context.appColor.primary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Figtree',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                      40.spaceh,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          CreateBranchScreenStrings.scheduleModalTimeLabel,
                          style: TextStyle(
                            color: context.appColor.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ),
                      20.spaceh,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildScheduleTimeField(
                                label: CreateBranchScreenStrings
                                    .scheduleModalStartLabel,
                                value: startTime,
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: 9, minute: 0),
                                  );
                                  if (time != null && context.mounted) {
                                    setModalState(() {
                                      startTime =
                                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                                    });
                                  }
                                },
                              ),
                            ),
                            19.spacew,
                            Expanded(
                              child: _buildScheduleTimeField(
                                label: CreateBranchScreenStrings
                                    .scheduleModalEndLabel,
                                value: endTime,
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: const TimeOfDay(
                                      hour: 21,
                                      minute: 0,
                                    ),
                                  );
                                  if (time != null && context.mounted) {
                                    setModalState(() {
                                      endTime =
                                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      40.spaceh,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: context.appColor.primary,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  final list = selectedDays.toList();
                                  list.sort(
                                    (a, b) => CreateBranchScreenStrings
                                        .scheduleModalDays
                                        .indexOf(a)
                                        .compareTo(
                                          CreateBranchScreenStrings
                                              .scheduleModalDays
                                              .indexOf(b),
                                        ),
                                  );
                                  final daysStr = list.join(', ');
                                  final display = daysStr.isEmpty
                                      ? '$startTime - $endTime'
                                      : '$daysStr: $startTime - $endTime';
                                  _formNotifier.setSchedule(display);
                                  Navigator.of(context).pop();
                                },
                                borderRadius: BorderRadius.circular(50),
                                child: Center(
                                  child: Text(
                                    CreateBranchScreenStrings
                                        .scheduleModalConfirm,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Figtree',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.appColor.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Figtree',
          ),
        ),
        8.spaceh,
        SizedBox(
          height: 77,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.appColor.primary, width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 38,
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: context.appColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColor.surface,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 35,
              height: 35,
              child: Icon(
                Icons.arrow_back,
                color: context.appColor.primary,
                size: 20,
              ),
            ),
          ),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          CreateBranchScreenStrings.appBarTitle,
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _formNotifier,
        builder: (context, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    20.spaceh,
                    _buildUploadBannerButton(),
                    20.spaceh,
                    CustomTextFormField(
                      labelText: _formNotifier.nameField.label,
                      hintText: _formNotifier.nameField.placeholder,
                      controller: _formNotifier.nameController,
                      errorText: _formNotifier.nameError,
                      keyboardType: TextInputType.text,
                      maxLength: _formNotifier.nameField.maxLength,
                      fieldHeight: 77,
                    ),

                    20.spaceh,
                    _buildSelectField(
                      context,
                      label: CreateBranchScreenStrings.categoryLabel,
                      hint: CreateBranchScreenStrings.categoryHint,
                      value: _formNotifier.selectedCategory,
                      onTap: _showCategoryBottomSheet,
                    ),
                    20.spaceh,
                    _buildSelectField(
                      context,
                      label: CreateBranchScreenStrings.subCategoryLabel,
                      hint: CreateBranchScreenStrings.subCategoryHint,
                      value: _formNotifier.selectedSubCategory,
                      onTap: _showSubCategoryBottomSheet,
                      enabled: _formNotifier.selectedCategory != null,
                    ),
                    20.spaceh,
                    CustomTextFormField(
                      labelText: _formNotifier.phoneField.label,
                      hintText: _formNotifier.phoneField.placeholder,
                      prefixText: '+51 ',
                      controller: _formNotifier.phoneController,
                      errorText: _formNotifier.phoneError,
                      keyboardType: TextInputType.phone,
                      maxLength: _formNotifier.phoneField.maxLength,
                      fieldHeight: 77,
                    ),
                    20.spaceh,
                    _buildSelectField(
                      context,
                      label: CreateBranchScreenStrings.scheduleLabel,
                      hint: CreateBranchScreenStrings.scheduleHint,
                      value: _formNotifier.selectedSchedule,
                      onTap: _showScheduleBottomSheet,
                      icon: Icons.access_time,
                    ),
                    20.spaceh,
                    _buildAddressAndMapSection(),
                    100.spaceh,
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 0,
                child: SafeArea(child: _buildCreateButton(context)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUploadBannerButton() {
    return SizedBox(
      height: 77,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColor.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _showImageSourceBottomSheet();
            },
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  color: context.appColor.primary,
                  size: 35,
                ),
                const SizedBox(width: 10),
                Text(
                  CreateBranchScreenStrings.uploadBanner,
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
    );
  }

  Widget _buildSelectField(
    BuildContext context, {
    required String label,
    required String hint,
    String? value,
    required VoidCallback onTap,
    IconData? icon,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: enabled
                ? context.appColor.onSurface
                : context.appColor.outline,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Figtree',
          ),
        ),
        8.spaceh,
        SizedBox(
          height: 77,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.appColor.primary, width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled ? onTap : null,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 26,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value ?? hint,
                            style: TextStyle(
                              color: value != null
                                  ? context.appColor.primary
                                  : enabled
                                  ? context.appColor.onSurfaceVariant
                                  : context.appColor.outline,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ),
                      ),
                      if (icon != null)
                        Icon(icon, color: context.appColor.primary, size: 24)
                      else
                        Icon(
                          Icons.arrow_drop_down,
                          color: enabled
                              ? context.appColor.primary
                              : context.appColor.outline,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static const double _defaultLng = -77.0428;
  static const double _defaultLat = -12.0464;

  Future<void> _onMapTapped(double lng, double lat) async {
    final service = getIt<MapboxGeocodingService>();
    final result = await service.reverseGeocode(lng, lat);
    if (!mounted) return;
    if (result != null) {
      _formNotifier.addressController.text = result.displayName;
      _formNotifier.addressController.selection = TextSelection.fromPosition(
        TextPosition(offset: result.displayName.length),
      );
      setState(() {
        _mapCenterLng = lng;
        _mapCenterLat = lat;
      });
    }
  }

  Widget _buildAddressAndMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.spaceh,
        Text(
          _formNotifier.addressField.label,
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
                  key: ValueKey(
                    'create_branch_map_${_mapCenterLat}_$_mapCenterLng',
                  ),
                  cameraOptions: CameraOptions(
                    center: Point(
                      coordinates: Position(_mapCenterLng, _mapCenterLat),
                    ),
                    zoom: 12,
                  ),
                  styleUri: MapboxStyles.MAPBOX_STREETS,
                  onTapListener: (MapContentGestureContext ctx) {
                    final lng = ctx.point.coordinates.lng.toDouble();
                    final lat = ctx.point.coordinates.lat.toDouble();
                    _onMapTapped(lng, lat);
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
                      controller: _formNotifier.addressController,
                      style: TextStyle(
                        color: context.appColor.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Figtree',
                      ),
                      decoration: InputDecoration(
                        hintText: _formNotifier.addressField.placeholder,
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
                        errorText: _formNotifier.addressError,
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

  Widget _buildCreateButton(BuildContext context) {
    final enabled = _formNotifier.isFormComplete;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: enabled
            ? () {
                // TODO: Implementar lógica de creación
                context.router.pop();
              }
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, size: 22),
            20.spacew,
            Text(
              CreateBranchScreenStrings.createBranchButton,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Figtree',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.appColor.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SizedBox(width: 131, height: 5),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.appColor.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: Icon(
                        Icons.arrow_back,
                        color: context.appColor.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      CreateBranchScreenStrings.chooseOptionTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.appColor.onSurface,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ),
                  const SizedBox(width: 35),
                ],
              ),
              const SizedBox(height: 30),
              _buildImageOption(
                icon: Icons.camera_alt,
                title: CreateBranchScreenStrings.takePhoto,
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implementar cámara
                  _formNotifier.setImagePath('placeholder');
                },
              ),
              const SizedBox(height: 20),
              _buildImageOption(
                icon: Icons.photo_library,
                title: CreateBranchScreenStrings.uploadFromGallery,
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implementar galería
                  _formNotifier.setImagePath('placeholder');
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Icon(icon, size: 27, color: context.appColor.onSurface),
              const SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  color: context.appColor.onSurface,
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Figtree',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
