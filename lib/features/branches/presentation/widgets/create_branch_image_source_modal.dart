import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';

/// Contenido del bottom sheet para elegir origen de imagen (cámara / galería).
class CreateBranchImageSourceModal extends StatelessWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onUploadFromGallery;

  const CreateBranchImageSourceModal({
    super.key,
    required this.onTakePhoto,
    required this.onUploadFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
            _BuildImageOption(
              icon: Icons.camera_alt,
              title: CreateBranchScreenStrings.takePhoto,
              onTap: onTakePhoto,
            ),
            const SizedBox(height: 20),
            _BuildImageOption(
              icon: Icons.photo_library,
              title: CreateBranchScreenStrings.uploadFromGallery,
              onTap: onUploadFromGallery,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _BuildImageOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _BuildImageOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
