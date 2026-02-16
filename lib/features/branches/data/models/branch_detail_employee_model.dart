import 'package:partners/features/branches/domain/entities/branch_detail_employee_entity.dart';

/// Modelo de empleado en respuesta GET /branch/{id}.employees[].
class BranchDetailEmployeeModel {
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

  const BranchDetailEmployeeModel({
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

  factory BranchDetailEmployeeModel.fromJson(Map<String, dynamic> json) {
    return BranchDetailEmployeeModel(
      id: json['id'] as String? ?? '',
      branchId: json['branch_id'] as String? ?? '',
      personId: json['person_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as bool? ?? true,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      photo: json['photo'] as String?,
      role: json['role'] as String? ?? 'employee',
    );
  }

  BranchDetailEmployeeEntity toEntity() {
    return BranchDetailEmployeeEntity(
      id: id,
      branchId: branchId,
      personId: personId,
      name: name,
      email: email,
      phone: phone,
      status: status,
      startDate: startDate,
      endDate: endDate,
      photo: photo,
      role: role,
    );
  }
}
