import 'package:partners/features/branches/data/models/branch_schedule_item_model.dart';
import 'package:partners/features/branches/domain/entities/branch_entity.dart';

/// Data model for Branch (Data Layer).
/// Parsea la respuesta GET /branch: data[].id, name, logo, address, phone_contacts, branchschedules.
class BranchModel extends BranchEntity {
  const BranchModel({
    required super.id,
    required super.name,
    required super.address,
    required super.phone,
    required super.schedule,
    required super.workers,
    super.imageUrl,
  });

  /// Desde un ítem del array data de la respuesta GET /branch.
  factory BranchModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    final name = json['name'] as String? ?? '';
    final logo = json['logo'] as String?;
    final address = json['address'] as String? ?? '';
    final phoneContacts = json['phone_contacts'] as String? ?? '';
    final branchschedules = json['branchschedules'] as List<dynamic>?;

    String schedule = '';
    if (branchschedules != null && branchschedules.isNotEmpty) {
      final first = branchschedules.first;
      if (first is Map<String, dynamic>) {
        final item = BranchScheduleItemModel.fromJson(first);
        schedule = item.toDisplayString();
      }
    }

    return BranchModel(
      id: id,
      name: name,
      address: address,
      phone: phoneContacts,
      schedule: schedule,
      workers: 0,
      imageUrl: logo,
    );
  }

  /// Parsea la respuesta completa { "data": [ ... ] } y devuelve la lista de modelos.
  static List<BranchModel> listFromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>?;
    if (data == null || data.isEmpty) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => BranchModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'schedule': schedule,
      'workers': workers,
      'imageUrl': imageUrl,
    };
  }

  BranchEntity toEntity() {
    return BranchEntity(
      id: id,
      name: name,
      address: address,
      phone: phone,
      schedule: schedule,
      workers: workers,
      imageUrl: imageUrl,
    );
  }
}
