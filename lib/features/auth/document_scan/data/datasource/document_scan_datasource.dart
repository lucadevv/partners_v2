import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';

/// Datasource para validación de documentos escaneados
abstract class DocumentScanDatasource {
  Future<Either<AppException, DocumentScanResult>> ocrData({
    required String imagePath,
  });
  Stream<Either<AppException, String>> watchDocumentRealtime({
    required CameraController cameraController,
    Duration interval = const Duration(seconds: 2),
  });
}
