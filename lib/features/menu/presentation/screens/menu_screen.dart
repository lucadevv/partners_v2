import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/utils/utils.dart';
import 'package:partners/core/widgets/widgets.dart';

@RoutePage()
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColor.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Herramientas Smart',
          textAlign: TextAlign.center,
          style: context.appTextTheme.titleLarge?.copyWith(
            color: context.appColor.onPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        padding: const EdgeInsets.all(20),
        childAspectRatio: 0.98,
        children: [
          _buildMenuCard(
            context,
            iconPath: IconPaths.h1,
            title: 'Encuestas\nSmart',
            onTap: () {
              // TODO: Navigate to surveys
            },
          ),
          _buildMenuCard(
            context,
            iconPath: IconPaths.h2,
            title: 'Promociones\nSmart',
            onTap: () {
              // TODO: Navigate to promotions
            },
          ),
          _buildMenuCard(
            context,
            iconPath: IconPaths.h3,
            title: 'Estudios de\nMercado\nSmart',
            onTap: () {
              // TODO: Navigate to market studies
            },
          ),
          _buildMenuCard(
            context,
            iconPath: IconPaths.h4,
            title: 'Ir a mi\nDashboard',
            onTap: () {
              // TODO: Navigate to dashboard
            },
          ),
          _buildMenuCard(
            context,
            iconPath: IconPaths.h5,
            title: 'Sucursales',
            onTap: () {
              // Navigate to branches - route will be available after build_runner
              // context.router.push(const BranchesRoute());
            },
          ),
          _buildMenuCard(
            context,
            iconPath: IconPaths.h6,
            title: 'Recibos\nSmart',
            onTap: () {
              // TODO: Navigate to receipts
            },
          ),
          _buildMenuCard(
            context,
            iconPath: IconPaths.h7,
            title: 'Estadísticas',
            onTap: () {
              // TODO: Navigate to statistics
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColor.onPrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgIconWidget(
                assetPath: iconPath,
                width: 44,
                height: 44,
                color: context.appColor.primary,
              ),
              8.spaceh,
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: context.appTextTheme.titleSmall?.copyWith(
                    color: context.appColor.primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Figtree',
                    fontSize: 20,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
