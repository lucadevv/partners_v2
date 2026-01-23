import 'package:partners/features/auth/document_scan/domain/entities/document_validation_response_entity.dart';

/// Modelo de respuesta de validación de documento
///
/// Representa los datos que retorna el backend
class DocumentValidationResponseModel
    extends DocumentValidationResponseEntity {
  const DocumentValidationResponseModel({
    required super.isValid,
    super.message,
    super.code,
  });

  /// Crea un modelo desde un mapa JSON
  factory DocumentValidationResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DocumentValidationResponseModel(
      isValid: json['isValid'] as bool? ?? false,
      message: json['message'] as String?,
      code: json['code'] as String?,
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      if (message != null) 'message': message,
      if (code != null) 'code': code,
    };
  }

  /// Crea una entidad desde el modelo
  DocumentValidationResponseEntity toEntity() {
    return DocumentValidationResponseEntity(
      isValid: isValid,
      message: message,
      code: code,
    );
  }
}
