import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/features/home/domain/entities/transaction_entity.dart';
import 'package:partners/features/home/presentation/widgets/transaction_item_widget.dart';

/// Widget for the transactions section
/// Follows Single Responsibility Principle (SRP)
class HomeTransactionsSection extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final Color backgroundColor;
  final VoidCallback? onViewAll;

  const HomeTransactionsSection({
    required this.transactions,
    required this.backgroundColor,
    this.onViewAll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Header
          Container(
            color: backgroundColor,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transacciones',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Figtree',
                  ),
                ),
                TextButton(
                  onPressed:
                      onViewAll ??
                      () {
                        context.router.push(const TransactionsRoute());
                      },
                  child: const Text(
                    'Ver completo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Transactions List
          if (transactions.isNotEmpty)
            ...transactions.map(
              (transaction) => Container(
                color: backgroundColor,
                child: TransactionItemWidget(transaction: transaction),
              ),
            ),
        ],
      ),
    );
  }
}
