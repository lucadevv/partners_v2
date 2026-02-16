import 'package:equatable/equatable.dart';

/// Domain entity representing a Branch (lista).
class BranchEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String schedule;
  final int workers;
  final String? imageUrl;

  /// "active" | "inactive" | otro; del backend.
  final String status;

  const BranchEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.schedule,
    required this.workers,
    this.imageUrl,
    this.status = 'active',
  });

  bool get isActive => status == 'active';

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    phone,
    schedule,
    workers,
    imageUrl,
    status,
  ];
}
