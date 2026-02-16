import 'package:equatable/equatable.dart';
import 'package:partners/features/branches/domain/entities/branch_detail_employee_entity.dart';
import 'package:partners/features/branches/domain/entities/branch_schedule_entity.dart';

/// Detalle de sucursal GET /branch/{id}.
class BranchDetailEntity extends Equatable {
  final String id;
  final String? subcategoryId;
  final String name;
  final String? logo;
  final String address;
  final String phoneContacts;
  final bool isMain;
  final String status;
  final List<BranchScheduleEntity> branchSchedules;
  final List<BranchDetailEmployeeEntity> employees;

  const BranchDetailEntity({
    required this.id,
    this.subcategoryId,
    required this.name,
    this.logo,
    required this.address,
    required this.phoneContacts,
    required this.isMain,
    required this.status,
    this.branchSchedules = const [],
    this.employees = const [],
  });

  bool get isActive => status == 'active';

  @override
  List<Object?> get props =>
      [id, subcategoryId, name, logo, address, phoneContacts, isMain, status, branchSchedules, employees];
}
