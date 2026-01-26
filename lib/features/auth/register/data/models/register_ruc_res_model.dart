import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';

class RegisterRucResModel {
  final bool? success;
  final bool? isExists;
  final Data? data;
  final bool? manualEntry;

  RegisterRucResModel({
    this.success,
    this.isExists,
    this.data,
    this.manualEntry,
  });

  RegisterRucResModel copyWith({
    bool? success,
    bool? isExists,
    Data? data,
    bool? manualEntry,
  }) => RegisterRucResModel(
    success: success ?? this.success,
    isExists: isExists ?? this.isExists,
    data: data ?? this.data,
    manualEntry: manualEntry ?? this.manualEntry,
  );

  factory RegisterRucResModel.fromJson(Map<String, dynamic> json) =>
      RegisterRucResModel(
        success: json["success"],
        isExists: json["is_exists"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        manualEntry: json["manual_entry"],
      );
}

class Data {
  final String? ruc;
  final String? socialReason;
  final dynamic tradeName;
  final String? address;
  final dynamic phoneContacts;
  final List<LegalRepresentative>? legalRepresentatives;
  final String? estado;
  final String? condicion;

  Data({
    this.ruc,
    this.socialReason,
    this.tradeName,
    this.address,
    this.phoneContacts,
    this.legalRepresentatives,
    this.estado,
    this.condicion,
  });

  Data copyWith({
    String? ruc,
    String? socialReason,
    dynamic tradeName,
    String? address,
    dynamic phoneContacts,
    List<LegalRepresentative>? legalRepresentatives,
    String? estado,
    String? condicion,
  }) => Data(
    ruc: ruc ?? this.ruc,
    socialReason: socialReason ?? this.socialReason,
    tradeName: tradeName ?? this.tradeName,
    address: address ?? this.address,
    phoneContacts: phoneContacts ?? this.phoneContacts,
    legalRepresentatives: legalRepresentatives ?? this.legalRepresentatives,
    estado: estado ?? this.estado,
    condicion: condicion ?? this.condicion,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    ruc: json["ruc"],
    socialReason: json["social_reason"],
    tradeName: json["trade_name"],
    address: json["address"],
    phoneContacts: json["phone_contacts"],
    legalRepresentatives: json["legal_representatives"] == null
        ? []
        : List<LegalRepresentative>.from(
            json["legal_representatives"]!.map(
              (x) => LegalRepresentative.fromJson(x),
            ),
          ),
    estado: json["estado"],
    condicion: json["condicion"],
  );
}

class LegalRepresentative {
  final TipoDocumento? tipoDocumento;
  final String? numeroDocumento;
  final String? nombre;
  final String? cargo;

  LegalRepresentative({
    this.tipoDocumento,
    this.numeroDocumento,
    this.nombre,
    this.cargo,
  });

  LegalRepresentative copyWith({
    TipoDocumento? tipoDocumento,
    String? numeroDocumento,
    String? nombre,
    String? cargo,
  }) => LegalRepresentative(
    tipoDocumento: tipoDocumento ?? this.tipoDocumento,
    numeroDocumento: numeroDocumento ?? this.numeroDocumento,
    nombre: nombre ?? this.nombre,
    cargo: cargo ?? this.cargo,
  );

  factory LegalRepresentative.fromJson(Map<String, dynamic> json) =>
      LegalRepresentative(
        tipoDocumento: json["tipo_documento"] == 'dni'
            ? TipoDocumento.dni
            : TipoDocumento.ce,
        numeroDocumento: json["numero_documento"],
        nombre: json["nombre"],
        cargo: json["cargo"],
      );
}
