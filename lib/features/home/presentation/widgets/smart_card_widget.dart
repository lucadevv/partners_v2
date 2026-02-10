import 'package:flutter/material.dart';
import 'package:partners/features/home/domain/entities/smart_card_entity.dart';

/// Widget to display the Smart Card with points balance
/// Follows Single Responsibility Principle (SRP)
class SmartCardWidget extends StatelessWidget {
  final SmartCardEntity card;

  const SmartCardWidget({
    required this.card,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 186,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 78.84,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 51.89,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background gradient layers
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF051858),
                  Color(0xFF1638AB),
                  Color(0xFF2759FF),
                  Color(0x9966CFFF),
                ],
                stops: [0.0, 0.25, 0.68, 1.0],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Smart Card label
                Row(
                  children: [
                    const Text(
                      'Smart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x9966CFFF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Card',
                        style: TextStyle(
                          color: Color(0xFF0F2A7A),
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Points balance
                Flexible(
                  child: Text(
                    '${card.pointsBalance} ${card.pointsLabel}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
