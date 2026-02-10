import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/utils/icon_paths.dart';
import 'package:partners/core/widgets/svg_icon_widget.dart';
import 'package:partners/features/home/domain/entities/smart_tool_entity.dart';

/// Widget to display a Smart Tool card
/// Follows Single Responsibility Principle (SRP)
class SmartToolCardWidget extends StatelessWidget {
  final SmartToolEntity tool;

  const SmartToolCardWidget({required this.tool, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToRoute(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 63,
            height: 63,
            decoration: BoxDecoration(
              color: tool.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgIconWidget(
                assetPath: _getIconPathForTool(tool.iconName),
                width: 30,
                height: 30,
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
                height: 1.2, // Mejorar espaciado para textos con \n
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
        return IconPaths.store; // assets/svg/store.svg
      case 'money':
        return IconPaths.gift; // assets/svg/buy_points.svg
      case 'arrow-up':
        return IconPaths.arrowUp; // assets/svg/send_points.svg
      case 'coin':
        return IconPaths.creditCard; // assets/svg/points.svg
      case 'gift':
        return IconPaths.coin; // assets/svg/winner.svg
      case 'analytics':
        return IconPaths.analytics; // assets/svg/analytics.svg
      case 'credit-card':
        return IconPaths.smartCard; // assets/svg/smart_card.svg
      case 'more':
        return IconPaths.add; // assets/svg/add.svg
      default:
        return IconPaths.add;
    }
  }

  void _navigateToRoute(BuildContext context) {
    // Navegar según la ruta definida en el tool
    // Las rutas son relativas al HomeShell
    switch (tool.route) {
      case '/branches':
        context.router.push(const BranchesRoute());
        break;
      case '/buy-points':
        context.router.push(const BuyPointsRoute());
        break;
      case '/issue-points':
        context.router.push(const IssuePointsRoute());
        break;
      case '/redeem-points':
        context.router.push(const RedeemPointsRoute());
        break;
      case '/prizes':
        context.router.push(const PrizesRoute());
        break;
      case '/analytics':
        context.router.push(const AnalyticsRoute());
        break;
      case '/smart-card':
        context.router.push(const SmartCardRoute());
        break;
      case '/more':
        context.router.push(const MoreToolsRoute());
        break;
      default:
        // No hacer nada si la ruta no está definida
        break;
    }
  }
}
