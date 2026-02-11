import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/transactions/data/datasource/transactions_datasource.dart';
import 'package:partners/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:partners/features/transactions/domain/entities/transaction_entity.dart';
import 'package:partners/features/transactions/domain/repository/transactions_repository.dart';

/// Repository implementation for Transactions feature (Data Layer)
class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsDatasource _datasource;

  TransactionsRepositoryImpl({required TransactionsDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<AppException, List<TransactionEntity>>> getTransactions() async {
    final result = await _datasource.getTransactions();
    return result.map(
      (models) => TransactionMapper.modelsToEntities(models),
    );
  }
}
