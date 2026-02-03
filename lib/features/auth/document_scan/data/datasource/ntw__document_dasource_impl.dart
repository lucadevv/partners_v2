import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:partners/core/services/database/flags/flags_factory.dart';
import 'package:partners/core/services/database/flags/session_id_flug.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/services/ocr/ocr_service.dart';
import 'package:partners/core/services/ocr/realtime_ocr_service.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/exception_handler.dart';
import 'package:partners/features/auth/document_scan/data/datasource/document_scan_datasource.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';

class NtwDocumentDasourceImpl implements DocumentScanDatasource {
  final ApiServices _services;
  final OcrService _ocrService;
  final RealtimeOcrService _realtimeOcrService;
  final SessionIdFlug _sessionFlug = FlagsFactory.createSessionIdFlug();

  NtwDocumentDasourceImpl({
    required ApiServices services,
    required OcrService ocrService,
    required RealtimeOcrService realtimeOcrService,
  }) : _services = services,
       _ocrService = ocrService,
       _realtimeOcrService = realtimeOcrService;
  @override
  Future<Either<AppException, DocumentScanResult>> ocrData({
    required String imagePath,
  }) async {
    try {
      final responseData = await _ocrService.scanComplete(imagePath);
      return Right(responseData);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'ocrData');
      return Left(appException);
    }
  }

  @override
  Stream<Either<AppException, String>> watchDocumentRealtime({
    required CameraController cameraController,
    Duration interval = const Duration(seconds: 3),
  }) {
    final controller = StreamController<Either<AppException, String>>();

    try {
      void callback(String text, String path) {
        if (!controller.isClosed) {
          controller.add(Right(text));
        }
      }

      _realtimeOcrService.start(
        cameraController: cameraController,
        interval: interval,

        onTextDetected: callback,
      );

      controller.onCancel = () {
        _realtimeOcrService.stop();
        if (!controller.isClosed) {
          controller.close();
        }
      };
    } catch (e) {
      if (!controller.isClosed) {
        controller.add(Left(ExceptionHandler.handleException(e)));
      }
    }

    return controller.stream;
  }

  @override
  Future<Either<AppException, String>> uploadIdentity({
    required DocumentScanResult scanResult,
  }) async {
    try {
      final String? sessionId = _sessionFlug.sessionId;
      if (sessionId == null || sessionId.isEmpty) {
        return Left(ValidationException('Session ID no encontrado'));
      }

      final doc = scanResult.document;

      final response = await _services.post(
        '/onboarding/upload-identity',
        data: {'session_id': sessionId, 'number': doc.number},
      );

      final responseData = response.data;
      final message =
          responseData['message'] as String? ??
          'Documento validado correctamente.';

      return Right(message);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'uploadIdentity');
      return Left(appException);
    }
  }

  void dispose() {
    _realtimeOcrService.stop();
  }
}
