import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:partners/core/services/services.dart';
import 'package:partners/main.dart';

/// Constantes para reducir tamaño de foto y evitar 413 Request Entity Too Large.
class _PhotoCompression {
  static const double maxWidth = 1024;
  static const double maxHeight = 1024;
  static const int imageQuality = 65;
}

/// Helper para cámara/galería al crear/editar empleado. Copia la imagen a temp y notifica por callback.
/// Usa maxWidth/maxHeight y imageQuality bajos para reducir el tamaño del multipart y evitar 413.
class EmployeePhotoPickerHandler {
  EmployeePhotoPickerHandler._();

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
          'employee_photo_${DateTime.now().millisecondsSinceEpoch}$ext',
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
    void Function(String path) onPath,
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
      maxWidth: _PhotoCompression.maxWidth,
      maxHeight: _PhotoCompression.maxHeight,
      imageQuality: _PhotoCompression.imageQuality,
    );
    if (!context.mounted) return;
    if (xFile != null && xFile.path.isNotEmpty) {
      final path = xFile.path;
      onPath(path);
      final copied = await _copyToAppTemp(xFile);
      if (context.mounted && copied != null && copied != path) {
        onPath(copied);
      }
    }
  }

  static Future<void> pickFromGallery(
    BuildContext context,
    void Function(String path) onPath,
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
      maxWidth: _PhotoCompression.maxWidth,
      maxHeight: _PhotoCompression.maxHeight,
      imageQuality: _PhotoCompression.imageQuality,
    );
    if (!context.mounted) return;
    if (xFile != null && xFile.path.isNotEmpty) {
      final path = xFile.path;
      onPath(path);
      final copied = await _copyToAppTemp(xFile);
      if (context.mounted && copied != null && copied != path) {
        onPath(copied);
      }
    }
  }
}
