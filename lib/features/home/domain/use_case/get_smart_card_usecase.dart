import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/home/domain/entities/smart_card_entity.dart';
import 'package:partners/features/home/domain/repository/home_repository.dart';

/// Use Case to get Smart Card information
/// Follows Single Responsibility Principle (SRP)
class GetSmartCardUsecase {
  final HomeRepository _repository;

  GetSmartCardUsecase({required HomeRepository repository})
      : _repository = repository;

  Future<Either<AppException, SmartCardEntity>> call() async {
    return await _repository.getSmartCard();
  }
}
