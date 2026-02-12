import 'dart:io';

import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';

/// Sección banner: previsualización en card arriba (si hay foto) y botón "Subir banner" abajo.
/// Fuente de verdad: solo [CreateBranchFormNotifier.imagePath]. Para cambiar la foto se pulsa de nuevo "Subir banner".
class CreateBranchUploadBanner extends StatelessWidget {
  final CreateBranchFormNotifier formNotifier;
  final VoidCallback onTap;

  const CreateBranchUploadBanner({
    super.key,
    required this.formNotifier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = formNotifier.imagePath;
    final hasImage =
        imagePath != null && imagePath.isNotEmpty && imagePath != 'placeholder';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasImage) ...[
          _PreviewCard(
            key: ValueKey<String>(imagePath),
            imagePath: imagePath,
            appColor: context.appColor,
          ),
          12.spaceh,
        ],
        _UploadButton(onTap: onTap, appColor: context.appColor),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String imagePath;
  final ColorScheme appColor;

  const _PreviewCard({
    super.key,
    required this.imagePath,
    required this.appColor,
  });

  static const double _previewHeight = 200;

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: appColor.onSurfaceVariant,
                  ),
                  8.spaceh,
                  Text(
                    'No se pudo cargar la imagen',
                    style: TextStyle(
                      color: appColor.onSurfaceVariant,
                      fontSize: 14,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  final VoidCallback onTap;
  final ColorScheme appColor;

  const _UploadButton({required this.onTap, required this.appColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 77,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appColor.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  color: appColor.primary,
                  size: 35,
                ),
                const SizedBox(width: 10),
                Text(
                  CreateBranchScreenStrings.uploadBanner,
                  style: TextStyle(
                    color: appColor.primary,
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
}
