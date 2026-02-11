import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/routes/routes.dart';

/// Bottom sheet "Tipos de promos": Promoción básica / Promoción segmentada
class PromoTypeBottomSheet extends StatelessWidget {
  const PromoTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tipos de promos',
                style: TextStyle(
                  color: context.appColor.onSurface,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Figtree',
                ),
              ),
              24.spaceh,
              _OptionTile(
                icon: Icons.campaign_outlined,
                label: 'Promoción básica',
                onTap: () {
                  Navigator.of(context).pop();
                  context.router.push(const CreateBasicPromoRoute());
                },
              ),
              16.spaceh,
              _OptionTile(
                icon: Icons.groups_outlined,
                label: 'Promoción segmentada',
                onTap: () {
                  Navigator.of(context).pop();
                  context.router.push(const CreateSegmentedPromoRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, color: context.appColor.primary, size: 28),
              16.spacew,
              Text(
                label,
                style: TextStyle(
                  color: context.appColor.primary,
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Figtree',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
