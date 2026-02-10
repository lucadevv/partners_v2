import 'package:equatable/equatable.dart';
import 'package:partners/features/home/domain/entities/smart_card_entity.dart';
import 'package:partners/features/home/domain/entities/smart_tool_entity.dart';
import 'package:partners/features/home/domain/entities/transaction_entity.dart';

/// State for Home cubit
class HomeState extends Equatable {
  final HomeStatus status;
  final List<SmartToolEntity> smartTools;
  final SmartCardEntity? smartCard;
  final List<TransactionEntity> recentTransactions;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.smartTools = const [],
    this.smartCard,
    this.recentTransactions = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<SmartToolEntity>? smartTools,
    SmartCardEntity? smartCard,
    List<TransactionEntity>? recentTransactions,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      smartTools: smartTools ?? this.smartTools,
      smartCard: smartCard ?? this.smartCard,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        smartTools,
        smartCard,
        recentTransactions,
        errorMessage,
      ];
}

enum HomeStatus { initial, loading, success, failure }
