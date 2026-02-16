import 'package:partners/features/employees/data/models/employee_model.dart';

/// Respuesta GET /employees-branch/{id} (data es un solo objeto).
class EmployeeDetailResponseModel {
  final EmployeeModel data;

  const EmployeeDetailResponseModel({required this.data});

  factory EmployeeDetailResponseModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>?;
    if (dataJson == null) {
      throw FormatException('employees-branch/{id}: data es requerido');
    }
    return EmployeeDetailResponseModel(
      data: EmployeeModel.fromJson(dataJson),
    );
  }
}
