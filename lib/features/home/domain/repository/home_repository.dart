import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/home/domain/entities/smart_card_entity.dart';
import 'package:partners/features/home/domain/entities/smart_tool_entity.dart';
import 'package:partners/features/home/domain/entities/transaction_entity.dart';

/// Repository interface for Home feature (Domain Layer)
/// Follows Dependency Inversion Principle (DIP)
abstract class HomeRepository {
  Future<Either<AppException, List<SmartToolEntity>>> getSmartTools();
  Future<Either<AppException, SmartCardEntity>> getSmartCard();
  Future<Either<AppException, List<TransactionEntity>>> getRecentTransactions();
}
