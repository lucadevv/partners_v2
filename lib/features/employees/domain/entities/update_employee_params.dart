import 'package:equatable/equatable.dart';

/// Parámetros para actualizar empleado (PUT /employees-branch/{id} multipart).
class UpdateEmployeeParams extends Equatable {
  final String email;
  final String name;
  final String lastName;
  final String branchId;
  final String roleId;
  final String? photoPath;

  const UpdateEmployeeParams({
    required this.email,
    required this.name,
    required this.lastName,
    required this.branchId,
    required this.roleId,
    this.photoPath,
  });

  @override
  List<Object?> get props => [email, name, lastName, branchId, roleId, photoPath];
}
