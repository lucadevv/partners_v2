import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Comprime una imagen de archivo: redimensiona (máx. [maxSize] px) y reencoda en JPEG con [quality].
/// Devuelve la ruta del archivo comprimido en temp o null si falla.
/// Evita 413 Request Entity Too Large al subir fotos.
Future<String?> compressImageFile(
  String filePath, {
  int maxSize = 1024,
  int quality = 70,
}) async {
  try {
    final bytes = await File(filePath).readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return null;

    img.Image resized = image;
    if (image.width > maxSize || image.height > maxSize) {
      if (image.width > image.height) {
        resized = img.copyResize(image, width: maxSize);
      } else {
        resized = img.copyResize(image, height: maxSize);
      }
    }

    final jpegBytes = img.encodeJpg(resized, quality: quality);

    final dir = await getTemporaryDirectory();
    final outPath = p.join(
      dir.path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await File(outPath).writeAsBytes(jpegBytes);
    return outPath;
  } catch (_) {
    return null;
  }
}
