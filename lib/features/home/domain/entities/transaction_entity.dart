import 'package:equatable/equatable.dart';

/// Domain entity representing a transaction
class TransactionEntity extends Equatable {
  final String id;
  final String merchantName;
  final DateTime date;
  final int points;
  final String? description;

  const TransactionEntity({
    required this.id,
    required this.merchantName,
    required this.date,
    required this.points,
    this.description,
  });

  @override
  List<Object?> get props => [id, merchantName, date, points, description];
}
