import 'package:equatable/equatable.dart';
import 'package:partners/features/transactions/domain/entities/transaction_entity.dart';

enum TransactionsStatus {
  initial,
  loading,
  success,
  failure,
}

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<TransactionEntity> transactions;
  final String? errorMessage;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionEntity>? transactions,
    String? errorMessage,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactions, errorMessage];
}
