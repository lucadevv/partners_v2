import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';

/// Modelo de respuesta del registro
/// 
/// Representa los datos que retorna el backend
class RegisterResponseModel extends RegisterResponseEntity {
  const RegisterResponseModel({
    super.nombres,
    super.apellidos,
    super.razonSocial,
  });

  /// Crea un modelo desde un mapa JSON
  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      nombres: json['nombres'] as String?,
      apellidos: json['apellidos'] as String?,
      razonSocial: json['razonSocial'] as String?,
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      if (nombres != null) 'nombres': nombres,
      if (apellidos != null) 'apellidos': apellidos,
      if (razonSocial != null) 'razonSocial': razonSocial,
    };
  }

  /// Crea una entidad desde el modelo
  RegisterResponseEntity toEntity() {
    return RegisterResponseEntity(
      nombres: nombres,
      apellidos: apellidos,
      razonSocial: razonSocial,
    );
  }
}
