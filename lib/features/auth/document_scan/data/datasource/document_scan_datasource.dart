import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_ocr_entity.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_validation_response_entity.dart';

/// Datasource para validación de documentos escaneados
abstract class DocumentScanDatasource {
  Future<Either<AppException, DocumentValidationResponseEntity>> validateDocument({
    required DocumentOcrEntity ocrData,
  });
}
