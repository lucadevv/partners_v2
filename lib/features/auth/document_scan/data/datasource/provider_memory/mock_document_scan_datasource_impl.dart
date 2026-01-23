import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/document_scan/data/datasource/document_scan_datasource.dart';
import 'package:partners/features/auth/document_scan/data/models/document_validation_response_model.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_ocr_entity.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_validation_response_entity.dart';

class MockDocumentScanDatasourceImpl implements DocumentScanDatasource {
  // Mock data para documentos válidos
  final Set<String> _validDocuments = {
    '12345678', // DNI válido
    '87654321', // DNI válido
    '11223344', // DNI válido
    'A12345678', // CE válido
    'AB1234567', // CE válido
  };

  @override
  Future<Either<AppException, DocumentValidationResponseEntity>>
  validateDocument({required DocumentOcrEntity ocrData}) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 800));

    // Validar que el documento tenga número
    if (ocrData.numeroDocumento.isEmpty) {
      return Left(ValidationException('Número de documento requerido'));
    }

    // Validar formato del documento
    final numeroDocumento = ocrData.numeroDocumento.trim();

    // Verificar si el documento está en la lista de válidos (mock)
    final isValid = _validDocuments.contains(numeroDocumento);

    if (isValid) {
      return Right(
        DocumentValidationResponseModel(
          isValid: true,
          message: 'Documento validado exitosamente',
          code: 'VALIDATED',
        ).toEntity(),
      );
    } else {
      // Para documentos no en la lista, simular validación exitosa si tiene formato correcto
      // En producción, esto se validaría con el backend real
      final hasValidFormat =
          numeroDocumento.length >= 8 && numeroDocumento.length <= 12;

      if (hasValidFormat) {
        return Right(
          DocumentValidationResponseModel(
            isValid: true,
            message: 'Documento validado exitosamente',
            code: 'VALIDATED',
          ).toEntity(),
        );
      } else {
        return Left(ValidationException('Formato de documento inválido'));
      }
    }
  }
}
