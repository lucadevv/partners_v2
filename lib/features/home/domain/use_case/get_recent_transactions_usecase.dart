import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/home/domain/entities/transaction_entity.dart';
import 'package:partners/features/home/domain/repository/home_repository.dart';

/// Use Case to get recent transactions
/// Follows Single Responsibility Principle (SRP)
class GetRecentTransactionsUsecase {
  final HomeRepository _repository;

  GetRecentTransactionsUsecase({required HomeRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<TransactionEntity>>> call() async {
    return await _repository.getRecentTransactions();
  }
}
