class DocumentResModel {
  final bool? success;
  final Data? data;

  DocumentResModel({this.success, this.data});

  DocumentResModel copyWith({bool? success, Data? data}) => DocumentResModel(
    success: success ?? this.success,
    data: data ?? this.data,
  );

  factory DocumentResModel.fromJson(Map<String, dynamic> json) =>
      DocumentResModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  final String? documentType;
  final String? documentNumber;
  final String? name;
  final String? lastName;
  final String? cargo;

  Data({
    this.documentType,
    this.documentNumber,
    this.name,
    this.lastName,
    this.cargo,
  });

  Data copyWith({
    String? documentType,
    String? documentNumber,
    String? name,
    String? lastName,
    String? cargo,
  }) => Data(
    documentType: documentType ?? this.documentType,
    documentNumber: documentNumber ?? this.documentNumber,
    name: name ?? this.name,
    lastName: lastName ?? this.lastName,
    cargo: cargo ?? this.cargo,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    documentType: json["document_type"],
    documentNumber: json["document_number"],
    name: json["name"],
    lastName: json["last_name"],
    cargo: json["cargo"],
  );
}
