import 'package:equatable/equatable.dart';
import 'package:partners/core/utils/validations/register_entity_validator.dart';
import 'package:partners/core/utils/validations/register_validation_error.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_comercio.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';

class RegisterEntity extends Equatable {
  final TipoComercio? tipoComercio;
  final TipoDocumento? tipoDocumento;
  final String? numeroDocumento;
  final String? nombres;
  final String? apellidos;
  final String? email;
  final String? whatsapp;
  final String? password;

  // Campos adicionales para RUC 20
  final String? razonSocial;
  final TipoDocumento? tipoDocumentoRepresentante;
  final String? numeroDocumentoRepresentante;

  const RegisterEntity({
    this.tipoComercio,
    this.tipoDocumento,
    this.numeroDocumento,
    this.nombres,
    this.apellidos,
    this.email,
    this.whatsapp,
    this.password,
    this.razonSocial,
    this.tipoDocumentoRepresentante,
    this.numeroDocumentoRepresentante,
  });

  @override
  List<Object?> get props => [
    tipoComercio,
    tipoDocumento,
    numeroDocumento,
    nombres,
    apellidos,
    email,
    whatsapp,
    password,
    razonSocial,
    tipoDocumentoRepresentante,
    numeroDocumentoRepresentante,
  ];

  List<RegisterValidationError> validate() {
    return RegisterEntityValidator.validate(this);
  }

  bool isValid() {
    return RegisterEntityValidator.isValid(this);
  }

  RegisterEntity copyWith({
    TipoComercio? tipoComercio,
    TipoDocumento? tipoDocumento,
    String? numeroDocumento,
    String? nombres,
    String? apellidos,
    String? email,
    String? whatsapp,
    String? password,
    String? razonSocial,
    TipoDocumento? tipoDocumentoRepresentante,
    String? numeroDocumentoRepresentante,
  }) {
    return RegisterEntity(
      tipoComercio: tipoComercio ?? this.tipoComercio,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      password: password ?? this.password,
      razonSocial: razonSocial ?? this.razonSocial,
      tipoDocumentoRepresentante:
          tipoDocumentoRepresentante ?? this.tipoDocumentoRepresentante,
      numeroDocumentoRepresentante:
          numeroDocumentoRepresentante ?? this.numeroDocumentoRepresentante,
    );
  }

  @override
  toString() {
    return 'RegisterEntity(tipoComercio: $tipoComercio\n, tipoDocumento: $tipoDocumento\n, numeroDocumento: $numeroDocumento\n, nombres: $nombres\n, apellidos: $apellidos\n, email: $email\n, whatsapp: $whatsapp\n, password: $password\n, razonSocial: $razonSocial\n, tipoDocumentoRepresentante: $tipoDocumentoRepresentante\n, numeroDocumentoRepresentante: $numeroDocumentoRepresentante\n)';
  }
}
