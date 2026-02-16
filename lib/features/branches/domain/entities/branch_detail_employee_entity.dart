import 'package:equatable/equatable.dart';

/// Empleado de una sucursal en el detalle GET /branch/{id}.
class BranchDetailEmployeeEntity extends Equatable {
  final String id;
  final String branchId;
  final String personId;
  final String name;
  final String? email;
  final String? phone;
  final bool status;
  final String? startDate;
  final String? endDate;
  final String? photo;
  final String role;

  const BranchDetailEmployeeEntity({
    required this.id,
    required this.branchId,
    required this.personId,
    required this.name,
    this.email,
    this.phone,
    required this.status,
    this.startDate,
    this.endDate,
    this.photo,
    required this.role,
  });

  @override
  List<Object?> get props =>
      [id, branchId, personId, name, email, phone, status, startDate, endDate, photo, role];
}
