import 'package:equatable/equatable.dart';

/// Domain entity representing a Branch
class BranchEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String schedule;
  final int workers;
  final String? imageUrl;

  const BranchEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.schedule,
    required this.workers,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phone,
        schedule,
        workers,
        imageUrl,
      ];
}
