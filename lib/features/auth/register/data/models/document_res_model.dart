/// Modelo de respuesta para validación de documento (DNI/CE)
class DocumentResModel {
  final bool? success;
  final DocumentData? data;
  final bool? manualEntry;

  DocumentResModel({
    this.success,
    this.data,
    this.manualEntry,
  });

  DocumentResModel copyWith({
    bool? success,
    DocumentData? data,
    bool? manualEntry,
  }) =>
      DocumentResModel(
        success: success ?? this.success,
        data: data ?? this.data,
        manualEntry: manualEntry ?? this.manualEntry,
      );

  factory DocumentResModel.fromJson(Map<String, dynamic> json) =>
      DocumentResModel(
        success: json["success"],
        data: json["data"] == null ? null : DocumentData.fromJson(json["data"]),
        manualEntry: json["manual_entry"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "manual_entry": manualEntry,
      };
}

class DocumentData {
  final String? documentNumber;
  final String? name;
  final String? lastName;
  final String? birthDate;
  final String? gender;
  final String? address;
  final int? ubigeo;

  DocumentData({
    this.documentNumber,
    this.name,
    this.lastName,
    this.birthDate,
    this.gender,
    this.address,
    this.ubigeo,
  });

  DocumentData copyWith({
    String? documentNumber,
    String? name,
    String? lastName,
    String? birthDate,
    String? gender,
    String? address,
    int? ubigeo,
  }) =>
      DocumentData(
        documentNumber: documentNumber ?? this.documentNumber,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        birthDate: birthDate ?? this.birthDate,
        gender: gender ?? this.gender,
        address: address ?? this.address,
        ubigeo: ubigeo ?? this.ubigeo,
      );

  factory DocumentData.fromJson(Map<String, dynamic> json) => DocumentData(
        documentNumber: json["document_number"],
        name: json["name"],
        lastName: json["last_name"],
        birthDate: json["birth_date"],
        gender: json["gender"],
        address: json["address"],
        ubigeo: json["ubigeo"],
      );

  Map<String, dynamic> toJson() => {
        "document_number": documentNumber,
        "name": name,
        "last_name": lastName,
        "birth_date": birthDate,
        "gender": gender,
        "address": address,
        "ubigeo": ubigeo,
      };
}
