import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';

class FreeBannerWidget extends StatelessWidget {
  const FreeBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.appColor.secondary,
            context.appColor.primary,
          ],
        ),
      ),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: Center(
          child: Text(
            "GRATIS X3 MESES",
            style: TextStyle(
              color: context.appColor.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 23,
            ),
          ),
        ),
      ),
    );
  }
}
