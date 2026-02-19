import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:partners/core/services/database/flags/flags_factory.dart';
import 'package:partners/core/services/database/flags/session_id_flug.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/services/ocr/ocr_service.dart';
import 'package:partners/core/services/ocr/realtime_ocr_service.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/exception_handler.dart';
import 'package:partners/core/utils/models/ce.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/features/auth/document_scan/data/datasource/document_scan_datasource.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/features/auth/document_scan/domain/parser/ce_parser.dart';

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
    Duration interval = const Duration(seconds: 2),
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

      // Solo campos esenciales para validación backend
      final payload = <String, dynamic>{
        'session_id': sessionId,
        'document_type': doc.type == DocumentType.ce ? 'CE' : 'DNI',
        'number': doc.number,
      };

      if (scanResult.extractedLastName != null &&
          scanResult.extractedLastName!.isNotEmpty &&
          CeParser.looksLikeValidPersonName(scanResult.extractedLastName)) {
        payload['surnames'] = scanResult.extractedLastName;
      }
      if (scanResult.extractedName != null &&
          scanResult.extractedName!.isNotEmpty &&
          CeParser.looksLikeValidPersonName(scanResult.extractedName)) {
        payload['names'] = scanResult.extractedName;
      }
      final dob = scanResult.extractedBirthDate;
      if (dob != null && dob.isNotEmpty && _isValidDobFormat(dob)) {
        payload['date_of_birth'] = dob;
      }

      if (doc is Dni) {
        if (doc.securityCode.isNotEmpty) {
          payload['security_code'] = doc.securityCode;
        }
        final expiry = doc.expiryDate;
        if (expiry != null &&
            expiry.isNotEmpty &&
            _isValidExpiryFormat(expiry)) {
          payload['date_of_expiry'] = expiry;
        }
      } else if (doc is Ce) {
        final expiry = doc.expiryDate;
        if (expiry != null &&
            expiry.isNotEmpty &&
            _isValidExpiryFormat(expiry)) {
          payload['date_of_expiry'] = expiry;
        }
      }

      if (doc is Ce) {
        debugPrint('lucadev [CE] payload to backend: $payload');
      } else if (doc is Dni) {
        debugPrint('lucadev [DNI] payload to backend: $payload');
      }

      final response = await _services.post(
        '/onboarding/upload-identity',
        data: payload,
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

  bool _isValidDobFormat(String s) {
    final parts = s.split('/');
    if (parts.length != 3) return false;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return false;
    if (d < 1 || d > 31 || m < 1 || m > 12) return false;
    return y >= 1900 && y <= 2010;
  }

  bool _isValidExpiryFormat(String s) {
    final parts = s.split('/');
    if (parts.length != 3) return false;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return false;
    if (d < 1 || d > 31 || m < 1 || m > 12) return false;
    return y >= 1990 && y <= 2100;
  }

  void dispose() {
    _realtimeOcrService.stop();
  }
}
