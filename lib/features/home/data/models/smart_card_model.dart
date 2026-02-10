import 'package:partners/features/home/domain/entities/smart_card_entity.dart';

/// Data model for Smart Card (Data Layer)
class SmartCardModel extends SmartCardEntity {
  const SmartCardModel({
    required super.cardNumber,
    required super.pointsBalance,
    required super.pointsLabel,
  });

  factory SmartCardModel.fromJson(Map<String, dynamic> json) {
    return SmartCardModel(
      cardNumber: json['cardNumber'] as String,
      pointsBalance: json['pointsBalance'] as int,
      pointsLabel: json['pointsLabel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'pointsBalance': pointsBalance,
      'pointsLabel': pointsLabel,
    };
  }

  SmartCardEntity toEntity() {
    return SmartCardEntity(
      cardNumber: cardNumber,
      pointsBalance: pointsBalance,
      pointsLabel: pointsLabel,
    );
  }
}
