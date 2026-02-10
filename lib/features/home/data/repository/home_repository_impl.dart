import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/home/data/datasource/home_datasource.dart';
import 'package:partners/features/home/data/mappers/home_mapper.dart';
import 'package:partners/features/home/domain/entities/smart_card_entity.dart';
import 'package:partners/features/home/domain/entities/smart_tool_entity.dart';
import 'package:partners/features/home/domain/entities/transaction_entity.dart';
import 'package:partners/features/home/domain/repository/home_repository.dart';

/// Repository implementation for Home feature (Data Layer)
/// Follows Dependency Inversion Principle (DIP)
class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasource _datasource;

  HomeRepositoryImpl({required HomeDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<AppException, List<SmartToolEntity>>> getSmartTools() async {
    final result = await _datasource.getSmartTools();
    return result.map(
      (models) => HomeMapper.toolModelsToEntities(models),
    );
  }

  @override
  Future<Either<AppException, SmartCardEntity>> getSmartCard() async {
    final result = await _datasource.getSmartCard();
    return result.map((model) => HomeMapper.cardModelToEntity(model));
  }

  @override
  Future<Either<AppException, List<TransactionEntity>>> getRecentTransactions() async {
    final result = await _datasource.getRecentTransactions();
    return result.map(
      (models) => HomeMapper.transactionModelsToEntities(models),
    );
  }
}
