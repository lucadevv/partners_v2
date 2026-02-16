import 'package:partners/features/employees/data/models/role_option_model.dart';

/// Respuesta GET /options/roles (data[]).
class OptionsRolesResponseModel {
  final List<RoleOptionModel> data;

  const OptionsRolesResponseModel({required this.data});

  factory OptionsRolesResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>?;
    final data = dataList != null
        ? dataList
            .map((e) => RoleOptionModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <RoleOptionModel>[];
    return OptionsRolesResponseModel(data: data);
  }
}
