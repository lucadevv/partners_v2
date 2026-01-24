import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/utils/logger/app_logger.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToLogin());
  }

  Future<void> _navigateToLogin() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      
      final router = context.router;
      router.replace(const LoginRoute());
    } catch (e, stackTrace) {
      AppLogger.error('Error en splash navigation', e, stackTrace, 'SplashScreen');
      if (mounted) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          try {
            context.router.replace(const LoginRoute());
          } catch (e2, stackTrace2) {
            AppLogger.error('Error al reintentar navegación', e2, stackTrace2, 'SplashScreen');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final backgroundColor = theme.tertiary;
    final secondaryColor = theme.secondary;
    final textColor = theme.onSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox.expand(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: secondaryColor.withValues(alpha: 0.64),
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
                color: textColor,
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
