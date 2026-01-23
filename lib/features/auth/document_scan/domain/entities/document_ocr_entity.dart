import 'package:equatable/equatable.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';

/// Entidad que contiene toda la información extraída del OCR del documento
class DocumentOcrEntity extends Equatable {
  /// Tipo de documento detectado (DNI o CE)
  final TipoDocumento tipoDocumento;

  /// Número de documento extraído (limpio, sin espacios ni caracteres especiales)
  final String numeroDocumento;

  /// Nombres completos extraídos del documento
  final String? nombres;

  /// Apellidos completos extraídos del documento
  final String? apellidos;

  /// Fecha de nacimiento extraída (formato: DD/MM/YYYY)
  final String? fechaNacimiento;

  /// Número de verificación del DNI (último dígito)
  final String? digitoVerificador;

  /// Texto completo extraído del OCR (para debugging)
  final String textoCompleto;

  /// Ruta de la imagen procesada
  final String imagePath;

  /// Confianza del reconocimiento (0.0 a 1.0)
  final double confianza;

  const DocumentOcrEntity({
    required this.tipoDocumento,
    required this.numeroDocumento,
    this.nombres,
    this.apellidos,
    this.fechaNacimiento,
    this.digitoVerificador,
    required this.textoCompleto,
    required this.imagePath,
    this.confianza = 1.0,
  });

  @override
  List<Object?> get props => [
        tipoDocumento,
        numeroDocumento,
        nombres,
        apellidos,
        fechaNacimiento,
        digitoVerificador,
        textoCompleto,
        imagePath,
        confianza,
      ];

  /// Crea una copia de la entidad con nuevos valores
  DocumentOcrEntity copyWith({
    TipoDocumento? tipoDocumento,
    String? numeroDocumento,
    String? nombres,
    String? apellidos,
    String? fechaNacimiento,
    String? digitoVerificador,
    String? textoCompleto,
    String? imagePath,
    double? confianza,
  }) {
    return DocumentOcrEntity(
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      digitoVerificador: digitoVerificador ?? this.digitoVerificador,
      textoCompleto: textoCompleto ?? this.textoCompleto,
      imagePath: imagePath ?? this.imagePath,
      confianza: confianza ?? this.confianza,
    );
  }
}
