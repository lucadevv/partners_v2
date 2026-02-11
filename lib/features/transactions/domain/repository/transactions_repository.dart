import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/transactions/domain/entities/transaction_entity.dart';

/// Repository interface for Transactions feature (Domain Layer)
abstract class TransactionsRepository {
  Future<Either<AppException, List<TransactionEntity>>> getTransactions();
}
