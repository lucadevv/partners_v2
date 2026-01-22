import 'package:equatable/equatable.dart';
import 'package:partners/core/utils/validations/register_response_entity_validator.dart';
import 'package:partners/core/utils/validations/register_response_validation_error.dart';

class RegisterResponseEntity extends Equatable {
  final String? nombres;
  final String? apellidos;
  final String? razonSocial;

  const RegisterResponseEntity({
    this.nombres,
    this.apellidos,
    this.razonSocial,
  });

  @override
  List<Object?> get props => [
        nombres,
        apellidos,
        razonSocial,
      ];

  /// Valida la entidad
  List<RegisterResponseValidationError> validate() {
    return RegisterResponseEntityValidator.validate(this);
  }

  /// Verifica si la entidad es válida
  bool isValid() {
    return RegisterResponseEntityValidator.isValid(this);
  }
}
