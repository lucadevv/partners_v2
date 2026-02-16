import 'dart:io';

import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/employees/presentation/screens/create_employee_screen_strings.dart';
import 'package:partners/features/employees/presentation/widgets/employee_photo_picker_handler.dart';
import 'package:partners/features/employees/presentation/widgets/employee_photo_source_modal.dart';

/// Sección "Agregar una foto": previsualización (si hay) + botón para elegir cámara/galería.
class CreateEmployeePhotoSection extends StatelessWidget {
  final String? imagePath;
  final ValueChanged<String?> onPathChanged;

  const CreateEmployeePhotoSection({
    super.key,
    required this.imagePath,
    required this.onPathChanged,
  });

  void _showImageSourceBottomSheet(BuildContext context) {
    final screenContext = context;
    showModalBottomSheet(
      context: screenContext,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => EmployeePhotoSourceModal(
        onTakePhoto: () {
          Navigator.pop(modalContext);
          EmployeePhotoPickerHandler.pickFromCamera(
            screenContext,
            onPathChanged,
          );
        },
        onUploadFromGallery: () {
          Navigator.pop(modalContext);
          EmployeePhotoPickerHandler.pickFromGallery(
            screenContext,
            onPathChanged,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imagePath != null && imagePath!.isNotEmpty && imagePath != 'placeholder';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasImage) ...[
          _PreviewCard(imagePath: imagePath!, appColor: context.appColor),
          12.spaceh,
        ],
        OutlinedButton.icon(
          onPressed: () => _showImageSourceBottomSheet(context),
          icon: const Icon(Icons.add_a_photo),
          label: const Text(CreateEmployeeScreenStrings.addPhoto),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String imagePath;
  final ColorScheme appColor;

  const _PreviewCard({
    required this.imagePath,
    required this.appColor,
  });

  static const double _previewHeight = 160;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _previewHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appColor.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: appColor.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
            height: _previewHeight,
            errorBuilder: (_, __, ___) => Center(
              child: Icon(
                Icons.person,
                size: 48,
                color: appColor.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
