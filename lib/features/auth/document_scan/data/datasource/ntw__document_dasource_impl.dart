import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
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
    Duration interval = const Duration(seconds: 2),
  }) {
    // Creamos un Stream para emitir datos al Bloc
    final controller = StreamController<Either<AppException, String>>();

    try {
      // Iniciamos el servicio
      void callback(String text, String path) {
        debugPrint('📨 Callback recibido con texto (${text.length} caracteres)');
        // Verificar que el controller no esté cerrado antes de agregar
        if (!controller.isClosed) {
          debugPrint('✅ Agregando texto al stream');
          controller.add(Right(text));
        } else {
          debugPrint('⚠️ StreamController está cerrado, no se puede agregar texto');
        }
      }

      _realtimeOcrService.start(
        cameraController: cameraController,
        interval: interval,
        // Aquí conectamos el callback del servicio con nuestro Stream
        onTextDetected: callback,
      );

      // Cuando el stream se cancele, detener el servicio y cerrar el controller
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

    // Retornamos el stream para que el Bloc lo escuche
    return controller.stream;
  }

  // Método para limpieza
  void dispose() {
    _realtimeOcrService.stop();
  }
}
