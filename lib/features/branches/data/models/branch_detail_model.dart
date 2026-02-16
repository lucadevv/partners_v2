import 'package:partners/features/branches/data/models/branch_detail_employee_model.dart';
import 'package:partners/features/branches/data/models/branch_schedule_item_model.dart';
import 'package:partners/features/branches/domain/entities/branch_detail_entity.dart';
import 'package:partners/features/branches/domain/entities/branch_detail_employee_entity.dart';
import 'package:partners/features/branches/domain/entities/branch_schedule_entity.dart';

/// Modelo de detalle GET /branch/{id} (objeto directo, no data[]).
class BranchDetailModel {
  final String id;
  final String? subcategoryId;
  final String name;
  final String? logo;
  final String address;
  final String phoneContacts;
  final bool isMain;
  final String status;
  final List<BranchScheduleItemModel> branchSchedules;
  final List<BranchDetailEmployeeModel> employees;

  const BranchDetailModel({
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

  factory BranchDetailModel.fromJson(Map<String, dynamic> json) {
    final schedulesList = json['branchschedules'] as List<dynamic>?;
    final schedules = schedulesList != null
        ? schedulesList
            .whereType<Map<String, dynamic>>()
            .map((e) => BranchScheduleItemModel.fromJson(e))
            .toList()
        : <BranchScheduleItemModel>[];

    final employeesList = json['employees'] as List<dynamic>?;
    final employees = employeesList != null
        ? employeesList
            .whereType<Map<String, dynamic>>()
            .map((e) => BranchDetailEmployeeModel.fromJson(e))
            .toList()
        : <BranchDetailEmployeeModel>[];

    return BranchDetailModel(
      id: json['id'] as String? ?? '',
      subcategoryId: json['subcategory_id'] as String?,
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
      address: json['address'] as String? ?? '',
      phoneContacts: json['phone_contacts'] as String? ?? '',
      isMain: json['is_main'] as bool? ?? false,
      status: json['status'] as String? ?? 'active',
      branchSchedules: schedules,
      employees: employees,
    );
  }

  BranchDetailEntity toEntity() {
    return BranchDetailEntity(
      id: id,
      subcategoryId: subcategoryId,
      name: name,
      logo: logo,
      address: address,
      phoneContacts: phoneContacts,
      isMain: isMain,
      status: status,
      branchSchedules: branchSchedules
          .map(
            (s) => BranchScheduleEntity(
              id: s.id,
              monday: s.monday,
              tuesday: s.tuesday,
              wednesday: s.wednesday,
              thursday: s.thursday,
              friday: s.friday,
              saturday: s.saturday,
              sunday: s.sunday,
              startTime: s.startTime,
              endTime: s.endTime,
            ),
          )
          .toList(),
      employees: employees.map((e) => e.toEntity()).toList(),
    );
  }
}
