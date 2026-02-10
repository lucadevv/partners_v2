import 'package:partners/features/home/data/models/smart_card_model.dart';
import 'package:partners/features/home/data/models/smart_tool_model.dart';
import 'package:partners/features/home/data/models/transaction_model.dart';
import 'package:partners/features/home/domain/entities/smart_card_entity.dart';
import 'package:partners/features/home/domain/entities/smart_tool_entity.dart';
import 'package:partners/features/home/domain/entities/transaction_entity.dart';

/// Mapper to convert between Models and Entities
/// Follows Single Responsibility Principle (SRP)
class HomeMapper {
  static SmartToolEntity toolModelToEntity(SmartToolModel model) {
    return model.toEntity();
  }

  static List<SmartToolEntity> toolModelsToEntities(
    List<SmartToolModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

  static SmartCardEntity cardModelToEntity(SmartCardModel model) {
    return model.toEntity();
  }

  static TransactionEntity transactionModelToEntity(TransactionModel model) {
    return model.toEntity();
  }

  static List<TransactionEntity> transactionModelsToEntities(
    List<TransactionModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
