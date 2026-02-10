import 'package:equatable/equatable.dart';

/// Domain entity representing a Smart Card with points balance
class SmartCardEntity extends Equatable {
  final String cardNumber;
  final int pointsBalance;
  final String pointsLabel; // e.g., "PS" for "Puntos Smart"

  const SmartCardEntity({
    required this.cardNumber,
    required this.pointsBalance,
    required this.pointsLabel,
  });

  @override
  List<Object?> get props => [cardNumber, pointsBalance, pointsLabel];
}
