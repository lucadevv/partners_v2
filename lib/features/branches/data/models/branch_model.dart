import 'package:partners/features/branches/domain/entities/branch_entity.dart';

/// Data model for Branch (Data Layer)
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

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      schedule: json['schedule'] as String,
      workers: json['workers'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
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
