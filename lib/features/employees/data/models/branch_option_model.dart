import 'package:partners/features/employees/domain/entities/branch_option_entity.dart';

/// Modelo de opción de sucursal (GET /options/branches data[]).
class BranchOptionModel {
  final String id;
  final String name;

  const BranchOptionModel({required this.id, required this.name});

  factory BranchOptionModel.fromJson(Map<String, dynamic> json) {
    return BranchOptionModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  BranchOptionEntity toEntity() => BranchOptionEntity(id: id, name: name);
}
