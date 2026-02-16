import 'package:equatable/equatable.dart';

/// Parámetros para crear empleado (POST /employees-branch multipart).
class CreateEmployeeParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String lastName;
  final String branchId;
  final String roleId;
  final String? photoPath;

  const CreateEmployeeParams({
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
    required this.branchId,
    required this.roleId,
    this.photoPath,
  });

  @override
  List<Object?> get props => [email, password, name, lastName, branchId, roleId, photoPath];
}
