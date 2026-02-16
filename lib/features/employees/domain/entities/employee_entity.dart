import 'package:equatable/equatable.dart';

/// Empleado asignado a una sucursal (respuesta GET /employees-branch).
class EmployeeEntity extends Equatable {
  final String id;
  final String branchId;
  final String personId;
  final String name;
  final bool status;
  final String? startDate;
  final String? endDate;
  final String? photo;
  final String role;
  final String? email;

  const EmployeeEntity({
    required this.id,
    required this.branchId,
    required this.personId,
    required this.name,
    required this.status,
    this.startDate,
    this.endDate,
    this.photo,
    required this.role,
    this.email,
  });

  @override
  List<Object?> get props =>
      [id, branchId, personId, name, status, startDate, endDate, photo, role, email];
}
