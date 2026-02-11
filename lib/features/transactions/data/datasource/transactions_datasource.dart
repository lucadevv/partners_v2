import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/transactions/data/models/transaction_model.dart';

/// Datasource interface for Transactions (Data Layer)
abstract class TransactionsDatasource {
  Future<Either<AppException, List<TransactionModel>>> getTransactions();
}
