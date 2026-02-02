import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/domain/repository/document_scan_repository.dart';

class WatchDocumentRealtTimeUsecase {
  final DocumentScanRepository _repository;

  WatchDocumentRealtTimeUsecase({required DocumentScanRepository repository})
    : _repository = repository;

  Stream<Either<AppException, String>> call({
    required CameraController cameraController,
    Duration interval = const Duration(seconds: 2),
  }) {
    return _repository.watchDocumentRealtime(
      cameraController: cameraController,
    );
  }
}
