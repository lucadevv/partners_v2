import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/core/routes/app_routes.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.router.replace(LoginRoute());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColor.tertiary,
      body: SizedBox.expand(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.appColor.secondary.withValues(alpha: 0.64),
                    blurRadius: 150,
                    spreadRadius: 150,
                  ),
                ],
              ),
              child: SizedBox(height: 100, width: 100),
            ),
            Text(
              "Puntos\nSmart\nPartnes",
              style: TextStyle(
                fontFamily: "FREDOKA",
                color: context.appColor.onSecondary,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
            Align(
              alignment: AlignmentGeometry.directional(0.3, 0.0),
              child: SvgPicture.asset('assets/svg/logo.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
