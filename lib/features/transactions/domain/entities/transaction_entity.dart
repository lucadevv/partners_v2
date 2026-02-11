import 'package:equatable/equatable.dart';

/// Domain entity representing a Transaction (puntos emitidos/canjeados)
class TransactionEntity extends Equatable {
  final String id;
  final String name;
  final String date;
  final int points;

  const TransactionEntity({
    required this.id,
    required this.name,
    required this.date,
    required this.points,
  });

  /// Formato de puntos para UI: "5 puntos" o "-3 puntos"
  String get pointsLabel => '$points puntos';

  @override
  List<Object?> get props => [id, name, date, points];
}
