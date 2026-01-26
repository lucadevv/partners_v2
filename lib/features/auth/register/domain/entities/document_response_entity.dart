import 'package:equatable/equatable.dart';

/// Entidad de respuesta para validación de documento (DNI/CE)
class DocumentResponseEntity extends Equatable {
  final bool success;
  final String documentNumber;
  final String name;
  final String? lastName;
  final String? birthDate;
  final String? gender;
  final String? address;
  final int? ubigeo;
  final bool manualEntry;

  const DocumentResponseEntity({
    required this.success,
    required this.documentNumber,
    required this.name,
    this.lastName,
    this.birthDate,
    this.gender,
    this.address,
    this.ubigeo,
    required this.manualEntry,
  });

  @override
  List<Object?> get props => [
        success,
        documentNumber,
        name,
        lastName,
        birthDate,
        gender,
        address,
        ubigeo,
        manualEntry,
      ];
}
