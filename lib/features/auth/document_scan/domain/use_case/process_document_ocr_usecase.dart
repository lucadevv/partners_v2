import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/data/services/ocr_service.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_ocr_entity.dart';

/// Use case para procesar documento con OCR
class ProcessDocumentOcrUsecase {
  final OcrService _ocrService;

  ProcessDocumentOcrUsecase({
    OcrService? ocrService,
  }) : _ocrService = ocrService ?? OcrService();

  /// Procesa una imagen de documento y extrae información con OCR
  Future<Either<AppException, DocumentOcrEntity>> execute({
    required String imagePath,
  }) async {
    try {
      final result = await _ocrService.processDocumentImage(imagePath);
      return Right(result);
    } catch (e) {
      return Left(ValidationException(e.toString()));
    }
  }
}
