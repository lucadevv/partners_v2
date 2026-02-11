import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/transactions/domain/entities/transaction_entity.dart';
import 'package:partners/features/transactions/domain/repository/transactions_repository.dart';

/// Use Case to get all transactions
class GetTransactionsUsecase {
  final TransactionsRepository _repository;

  GetTransactionsUsecase({required TransactionsRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<TransactionEntity>>> call() async {
    return _repository.getTransactions();
  }
}
