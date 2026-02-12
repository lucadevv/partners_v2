import 'package:equatable/equatable.dart';

/// Parámetros de dominio para crear una sucursal (POST /branch).
/// Solo subcategory_id; categoría se usa en UI pero el backend pide subcategoría.
class CreateBranchParams extends Equatable {
  final String subcategoryId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phoneContacts;
  final String? logoPath;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;
  final String startTime;
  final String endTime;

  const CreateBranchParams({
    required this.subcategoryId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phoneContacts,
    this.logoPath,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [
        subcategoryId,
        name,
        address,
        latitude,
        longitude,
        phoneContacts,
        logoPath,
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
        sunday,
        startTime,
        endTime,
      ];
}
