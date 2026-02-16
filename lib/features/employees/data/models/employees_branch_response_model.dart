import 'package:partners/features/employees/data/models/employee_model.dart';

/// Respuesta paginada GET /employees-branch (data, links, meta).
class EmployeesBranchResponseModel {
  final List<EmployeeModel> data;
  final EmployeesBranchMeta meta;

  const EmployeesBranchResponseModel({
    required this.data,
    required this.meta,
  });

  factory EmployeesBranchResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>?;
    final data = dataList != null
        ? dataList
            .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <EmployeeModel>[];
    final metaJson = json['meta'] as Map<String, dynamic>?;
    final meta = metaJson != null
        ? EmployeesBranchMeta.fromJson(metaJson)
        : const EmployeesBranchMeta(
            currentPage: 1,
            lastPage: 1,
            perPage: 15,
            total: 0,
          );
    return EmployeesBranchResponseModel(data: data, meta: meta);
  }
}

class EmployeesBranchMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const EmployeesBranchMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory EmployeesBranchMeta.fromJson(Map<String, dynamic> json) {
    return EmployeesBranchMeta(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 15,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}
