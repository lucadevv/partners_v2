import 'package:flutter/material.dart';
import 'package:partners/features/home/domain/entities/transaction_entity.dart';

/// Widget to display a transaction item
/// Follows Single Responsibility Principle (SRP)
class TransactionItemWidget extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionItemWidget({
    required this.transaction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${transaction.date.day}/${transaction.date.month}/${transaction.date.year} - ${transaction.date.hour}:${transaction.date.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.merchantName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${transaction.points} points',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.w600,
                fontFamily: 'Figtree',
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
