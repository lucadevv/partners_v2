import 'package:flutter/material.dart';
import 'package:partners/core/utils/icon_paths.dart';
import 'package:partners/core/widgets/svg_icon_widget.dart';
import 'package:partners/features/home/domain/entities/smart_tool_entity.dart';

/// Widget to display a Smart Tool card
/// Follows Single Responsibility Principle (SRP)
class SmartToolCardWidget extends StatelessWidget {
  final SmartToolEntity tool;

  const SmartToolCardWidget({
    required this.tool,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tool tap - navigate to route
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 63,
            height: 63,
            decoration: BoxDecoration(
              color: const Color(0xFF66CFFF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgIconWidget(
                assetPath: _getIconPathForTool(tool.iconName),
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              tool.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.normal,
                fontFamily: 'Figtree',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _getIconPathForTool(String iconName) {
    switch (iconName) {
      case 'store':
        return IconPaths.store;
      case 'money':
        return IconPaths.money;
      case 'arrow-up':
        return IconPaths.arrowUp;
      case 'coin':
        return IconPaths.coin;
      case 'gift':
        return IconPaths.gift;
      case 'analytics':
        return IconPaths.analytics;
      case 'credit-card':
        return IconPaths.creditCard;
      case 'more':
        return IconPaths.menu;
      default:
        return IconPaths.menu;
    }
  }
}
