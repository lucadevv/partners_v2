import 'package:equatable/equatable.dart';

/// Opción de sucursal para selector (GET /options/branches).
class BranchOptionEntity extends Equatable {
  final String id;
  final String name;

  const BranchOptionEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
