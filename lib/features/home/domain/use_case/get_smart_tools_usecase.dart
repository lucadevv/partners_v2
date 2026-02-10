import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/home/domain/entities/smart_tool_entity.dart';
import 'package:partners/features/home/domain/repository/home_repository.dart';

/// Use Case to get all Smart Tools
/// Follows Single Responsibility Principle (SRP)
class GetSmartToolsUsecase {
  final HomeRepository _repository;

  GetSmartToolsUsecase({required HomeRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<SmartToolEntity>>> call() async {
    return await _repository.getSmartTools();
  }
}
