import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/data/datasource/document_scan_datasource.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_ocr_entity.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_validation_response_entity.dart';
import 'package:partners/features/auth/document_scan/domain/repository/document_scan_repository.dart';

class DocumentScanRepositoryImpl implements DocumentScanRepository {
  final DocumentScanDatasource _datasource;

  DocumentScanRepositoryImpl({
    required DocumentScanDatasource datasource,
  }) : _datasource = datasource;

  @override
  Future<Either<AppException, DocumentValidationResponseEntity>> validateDocument({
    required DocumentOcrEntity ocrData,
  }) {
    return _datasource.validateDocument(ocrData: ocrData);
  }
}
