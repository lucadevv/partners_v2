import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/widgets/custom_text_form_field.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';
import 'package:partners/features/branches/presentation/widgets/create_branch_address_map_section.dart';
import 'package:partners/features/branches/presentation/widgets/create_branch_select_field.dart';
import 'package:partners/features/branches/presentation/widgets/create_branch_upload_banner.dart';

/// Cuerpo del formulario crear sucursal: banner, campos y sección dirección+mapa.
class CreateBranchFormBody extends StatelessWidget {
  final CreateBranchFormNotifier formNotifier;
  final double mapCenterLng;
  final double mapCenterLat;
  final double? markerLng;
  final double? markerLat;
  final double mapZoom;
  final VoidCallback onShowCategory;
  final VoidCallback onShowSubcategory;
  final VoidCallback onShowSchedule;
  final VoidCallback onShowImageSource;
  final void Function(double lng, double lat) onMapTapped;
  final void Function(MapboxMap mapboxMap) onMapCreated;

  const CreateBranchFormBody({
    super.key,
    required this.formNotifier,
    required this.mapCenterLng,
    required this.mapCenterLat,
    this.markerLng,
    this.markerLat,
    required this.mapZoom,
    required this.onShowCategory,
    required this.onShowSubcategory,
    required this.onShowSchedule,
    required this.onShowImageSource,
    required this.onMapTapped,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.spaceh,
        CreateBranchUploadBanner(
          formNotifier: formNotifier,
          onTap: onShowImageSource,
        ),
        20.spaceh,
        CustomTextFormField(
          labelText: formNotifier.nameField.label,
          hintText: formNotifier.nameField.placeholder,
          controller: formNotifier.nameController,
          errorText: formNotifier.nameError,
          keyboardType: TextInputType.text,
          maxLength: formNotifier.nameField.maxLength,
          fieldHeight: 77,
        ),
        20.spaceh,
        CreateBranchSelectField(
          label: CreateBranchScreenStrings.categoryLabel,
          hint: CreateBranchScreenStrings.categoryHint,
          value: formNotifier.selectedCategory,
          onTap: onShowCategory,
        ),
        20.spaceh,
        CreateBranchSelectField(
          label: CreateBranchScreenStrings.subCategoryLabel,
          hint: CreateBranchScreenStrings.subCategoryHint,
          value: formNotifier.selectedSubCategory,
          onTap: onShowSubcategory,
          enabled: formNotifier.selectedCategory != null,
        ),
        20.spaceh,
        CustomTextFormField(
          labelText: formNotifier.phoneField.label,
          hintText: formNotifier.phoneField.placeholder,
          prefixText: '+51 ',
          controller: formNotifier.phoneController,
          errorText: formNotifier.phoneError,
          keyboardType: TextInputType.phone,
          maxLength: formNotifier.phoneField.maxLength,
          fieldHeight: 77,
        ),
        20.spaceh,
        CreateBranchSelectField(
          label: CreateBranchScreenStrings.scheduleLabel,
          hint: CreateBranchScreenStrings.scheduleHint,
          value: formNotifier.selectedSchedule,
          onTap: onShowSchedule,
          icon: Icons.access_time,
        ),
        20.spaceh,
        CreateBranchAddressMapSection(
          formNotifier: formNotifier,
          mapCenterLng: mapCenterLng,
          mapCenterLat: mapCenterLat,
          markerLng: markerLng,
          markerLat: markerLat,
          mapZoom: mapZoom,
          onMapTapped: onMapTapped,
          onMapCreated: onMapCreated,
        ),
        100.spaceh,
      ],
    );
  }
}
