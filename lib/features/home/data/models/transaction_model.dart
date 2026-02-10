import 'package:partners/features/home/domain/entities/transaction_entity.dart';

/// Data model for Transaction (Data Layer)
class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.merchantName,
    required super.date,
    required super.points,
    super.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      merchantName: json['merchantName'] as String,
      date: DateTime.parse(json['date'] as String),
      points: json['points'] as int,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantName': merchantName,
      'date': date.toIso8601String(),
      'points': points,
      'description': description,
    };
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      merchantName: merchantName,
      date: date,
      points: points,
      description: description,
    );
  }
}
