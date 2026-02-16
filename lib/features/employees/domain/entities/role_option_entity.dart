import 'package:equatable/equatable.dart';

/// Opción de rol para selector (GET /options/roles).
class RoleOptionEntity extends Equatable {
  final String id;
  final String name;

  const RoleOptionEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
