import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/branch_detail_entity.dart';
import 'package:partners/features/branches/domain/repository/branches_repository.dart';

/// Caso de uso: detalle de sucursal GET /branch/{id}.
class GetBranchByIdUsecase {
  GetBranchByIdUsecase({required BranchesRepository repository})
      : _repository = repository;

  final BranchesRepository _repository;

  Future<Either<AppException, BranchDetailEntity>> call(String id) {
    return _repository.getBranchById(id);
  }
}
