import 'package:partners/features/transactions/data/models/transaction_model.dart';
import 'package:partners/features/transactions/domain/entities/transaction_entity.dart';

/// Mapper between TransactionModel and TransactionEntity
class TransactionMapper {
  static TransactionEntity modelToEntity(TransactionModel model) {
    return model.toEntity();
  }

  static List<TransactionEntity> modelsToEntities(List<TransactionModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
