import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';

abstract class DocumentScanRepository {
  Future<Either<AppException, DocumentScanResult>> ocrData({
    required String imagePath,
  });
  Stream<Either<AppException, String>> watchDocumentRealtime({
    required CameraController cameraController,
    Duration interval = const Duration(seconds: 2),
  });
  Future<Either<AppException, String>> uploadIdentity({
    required DocumentScanResult scanResult,
  });
}
