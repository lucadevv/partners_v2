import 'package:equatable/equatable.dart';

/// Entidad de respuesta de validación de documento
class DocumentValidationResponseEntity extends Equatable {
  /// Indica si el documento fue validado exitosamente
  final bool isValid;

  /// Mensaje de respuesta del backend
  final String? message;

  /// Código de respuesta (opcional)
  final String? code;

  const DocumentValidationResponseEntity({
    required this.isValid,
    this.message,
    this.code,
  });

  @override
  List<Object?> get props => [
        isValid,
        message,
        code,
      ];
}
