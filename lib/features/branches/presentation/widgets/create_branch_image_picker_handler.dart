import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:partners/core/services/services.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/main.dart';

/// Helper para cámara/galería en crear sucursal: permisos + picker + actualizar notifier.
/// Copia la imagen a un path estable para que la previsualización (Image.file) funcione en todas las plataformas.
class CreateBranchImagePickerHandler {
  CreateBranchImagePickerHandler._();

  /// Copia el XFile a un archivo temporal de la app y devuelve su path (legible por Image.file).
  static Future<String?> _copyToAppTemp(img.XFile xFile) async {
    try {
      final bytes = await xFile.readAsBytes();
      final dir = await getTemporaryDirectory();
      final ext = p.extension(xFile.name).isEmpty
          ? '.jpg'
          : p.extension(xFile.name);
      final file = File(
        p.join(
          dir.path,
          'branch_banner_${DateTime.now().millisecondsSinceEpoch}$ext',
        ),
      );
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  static Future<void> pickFromCamera(
    BuildContext context,
    CreateBranchFormNotifier formNotifier,
  ) async {
    final status = await getIt<CameraPermissionService>().request();
    if (!context.mounted) return;
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se necesita permiso de cámara para tomar la foto'),
        ),
      );
      return;
    }
    final xFile = await img.ImagePicker().pickImage(
      source: img.ImageSource.camera,
      imageQuality: 85,
    );
    if (!context.mounted) return;
    if (xFile != null && xFile.path.isNotEmpty) {
      final path = xFile.path;
      formNotifier.setImagePath(path);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        formNotifier.setImagePath(formNotifier.imagePath ?? path);
      });
      _copyToAppTemp(xFile).then((copied) {
        if (copied != null && copied != path) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            formNotifier.setImagePath(copied);
          });
        }
      });
    }
  }

  static Future<void> pickFromGallery(
    BuildContext context,
    CreateBranchFormNotifier formNotifier,
  ) async {
    final status = await getIt<PhotosPermissionService>().request();
    if (!context.mounted) return;
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se necesita permiso de fotos para elegir una imagen'),
        ),
      );
      return;
    }
    final xFile = await img.ImagePicker().pickImage(
      source: img.ImageSource.gallery,
      imageQuality: 85,
    );
    if (!context.mounted) return;
    if (xFile != null && xFile.path.isNotEmpty) {
      final path = xFile.path;
      formNotifier.setImagePath(path);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        formNotifier.setImagePath(formNotifier.imagePath ?? path);
      });
      _copyToAppTemp(xFile).then((copied) {
        if (copied != null && copied != path) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            formNotifier.setImagePath(copied);
          });
        }
      });
    }
  }
}
