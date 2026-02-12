import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/create_branch_params.dart';
import 'package:partners/features/branches/domain/repository/branches_repository.dart';

/// Caso de uso: crear sucursal (POST /branch).
/// El backend retorna { "message": "Sucursal creada con éxito" }; se devuelve ese mensaje.
class CreateBranchUseCase {
  CreateBranchUseCase({required BranchesRepository repository})
      : _repository = repository;

  final BranchesRepository _repository;

  Future<Either<AppException, String>> call(CreateBranchParams params) async {
    final validationError = _validate(params);
    if (validationError != null) {
      return Left(ValidationException(validationError));
    }
    return _repository.createBranch(params);
  }

  String? _validate(CreateBranchParams params) {
    if (params.subcategoryId.trim().isEmpty) {
      return 'Debe seleccionar una subcategoría';
    }
    if (params.name.trim().isEmpty) {
      return 'El nombre es requerido';
    }
    if (params.name.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    if (params.address.trim().isEmpty) {
      return 'La dirección es requerida';
    }
    if (params.latitude < -90 || params.latitude > 90) {
      return 'Latitud inválida';
    }
    if (params.longitude < -180 || params.longitude > 180) {
      return 'Longitud inválida';
    }
    if (params.phoneContacts.trim().isEmpty) {
      return 'El teléfono es requerido';
    }
    if (params.startTime.isEmpty || params.endTime.isEmpty) {
      return 'Debe configurar horario de inicio y fin';
    }
    return null;
  }
}
