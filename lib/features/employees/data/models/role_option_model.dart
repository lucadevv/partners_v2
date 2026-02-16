import 'package:partners/features/employees/domain/entities/role_option_entity.dart';

/// Modelo de opción de rol (GET /options/roles data[]).
class RoleOptionModel {
  final String id;
  final String name;

  const RoleOptionModel({required this.id, required this.name});

  factory RoleOptionModel.fromJson(Map<String, dynamic> json) {
    return RoleOptionModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  RoleOptionEntity toEntity() {
    return RoleOptionEntity(id: id, name: name);
  }
}
