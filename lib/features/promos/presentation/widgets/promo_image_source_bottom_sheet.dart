import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partners/core/extension/extension.dart';

/// Bottom sheet para elegir origen de la imagen: cámara o galería.
/// Si [currentImagePath] no es null, muestra opciones "Ver imagen", "Volver a tomar", "Cambiar por otra".
void showPromoImageSourceBottomSheet(
  BuildContext context, {
  String? currentImagePath,
  required void Function(String path) onImageSelected,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _PromoImageSourceSheet(
      currentImagePath: currentImagePath,
      onImageSelected: onImageSelected,
    ),
  );
}

class _PromoImageSourceSheet extends StatelessWidget {
  final String? currentImagePath;
  final void Function(String path) onImageSelected;

  const _PromoImageSourceSheet({
    this.currentImagePath,
    required this.onImageSelected,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    Navigator.of(context).pop();
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (file != null && file.path.isNotEmpty) {
      onImageSelected(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = currentImagePath != null && currentImagePath!.isNotEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  hasImage ? 'Sobre su imagen' : 'Elige una opción',
                  style: TextStyle(
                    color: context.appColor.onSurface,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
              24.spaceh,
              if (hasImage) ...[
                _OptionRow(
                  icon: Icons.visibility_outlined,
                  label: 'Ver imagen',
                  onTap: () {
                    Navigator.of(context).pop();
                    // Opcional: navegar a fullscreen o dialog con la imagen
                  },
                ),
                16.spaceh,
              ],
              _OptionRow(
                icon: Icons.camera_alt_outlined,
                label: hasImage ? 'Volver a tomar foto con cámara' : 'Tomar foto con cámara',
                onTap: () => _pickImage(context, ImageSource.camera),
              ),
              16.spaceh,
              _OptionRow(
                icon: Icons.photo_library_outlined,
                label: hasImage ? 'Cambiar por otra foto de galería' : 'Subir foto de galería',
                onTap: () => _pickImage(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Icon(icon, color: context.appColor.primary, size: 27),
              16.spacew,
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: context.appColor.primary,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Figtree',
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
