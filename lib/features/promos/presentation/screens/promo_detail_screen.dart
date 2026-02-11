import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';

@RoutePage()
class PromoDetailScreen extends StatelessWidget {
  final String promoId;

  const PromoDetailScreen({super.key, required this.promoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.appColor.primary),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'La promo Smart',
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.appColor.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 323,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: context.appColor.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
