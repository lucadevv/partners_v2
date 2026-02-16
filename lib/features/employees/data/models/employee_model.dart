import 'package:partners/features/employees/domain/entities/employee_entity.dart';

/// Modelo de empleado (GET /employees-branch data[]).
class EmployeeModel {
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

  const EmployeeModel({
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

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String? ?? '',
      branchId: json['branch_id'] as String? ?? '',
      personId: json['person_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as bool? ?? true,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      photo: json['photo'] as String?,
      role: json['role'] as String? ?? 'employee',
      email: json['email'] as String?,
    );
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
      id: id,
      branchId: branchId,
      personId: personId,
      name: name,
      status: status,
      startDate: startDate,
      endDate: endDate,
      photo: photo,
      role: role,
      email: email,
    );
  }
}
