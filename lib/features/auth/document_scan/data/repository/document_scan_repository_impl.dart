import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/data/datasource/document_scan_datasource.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/features/auth/document_scan/domain/repository/document_scan_repository.dart';

class DocumentScanRepositoryImpl implements DocumentScanRepository {
  final DocumentScanDatasource _datasource;

  DocumentScanRepositoryImpl({required DocumentScanDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Either<AppException, DocumentScanResult>> ocrData({
    required String imagePath,
  }) {
    return _datasource.ocrData(imagePath: imagePath);
  }

  @override
  Stream<Either<AppException, String>> watchDocumentRealtime({
    required CameraController cameraController,
    Duration interval = const Duration(seconds: 2),
  }) {
    return _datasource.watchDocumentRealtime(
      cameraController: cameraController,
    );
  }

  @override
  Future<Either<AppException, String>> uploadIdentity({
    required DocumentScanResult scanResult,
  }) {
    return _datasource.uploadIdentity(scanResult: scanResult);
  }
}
