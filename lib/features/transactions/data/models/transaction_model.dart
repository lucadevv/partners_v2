import 'package:partners/features/transactions/domain/entities/transaction_entity.dart';

/// Data model for Transaction (Data Layer)
class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.name,
    required super.date,
    required super.points,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['date'] as String,
      points: json['points'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'points': points,
    };
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      name: name,
      date: date,
      points: points,
    );
  }
}
