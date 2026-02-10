import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/home/data/models/smart_card_model.dart';
import 'package:partners/features/home/data/models/smart_tool_model.dart';
import 'package:partners/features/home/data/models/transaction_model.dart';

/// Datasource interface for Home feature (Data Layer)
/// Follows Dependency Inversion Principle (DIP)
abstract class HomeDatasource {
  Future<Either<AppException, List<SmartToolModel>>> getSmartTools();
  Future<Either<AppException, SmartCardModel>> getSmartCard();
  Future<Either<AppException, List<TransactionModel>>> getRecentTransactions();
}
