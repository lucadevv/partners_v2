import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    super.initState();
    debugPrint('🎬 SplashScreen initState');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('⏱️ SplashScreen: Esperando 2 segundos...');
      try {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          debugPrint('🚀 SplashScreen: Navegando a LoginRoute...');
          context.router.replace(const LoginRoute());
          debugPrint('✅ SplashScreen: Navegación completada');
        } else {
          debugPrint(
            '⚠️ SplashScreen: Widget no montado, cancelando navegación',
          );
        }
      } catch (e, stackTrace) {
        // Si hay error en la navegación, intentar de nuevo
        debugPrint('❌ Error en splash navigation: $e');
        debugPrint('Stack trace: $stackTrace');
        if (mounted) {
          debugPrint('🔄 Reintentando navegación...');
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            try {
              context.router.replace(const LoginRoute());
              debugPrint('✅ Navegación exitosa en reintento');
            } catch (e2, stackTrace2) {
              debugPrint('❌ Error al reintentar navegación: $e2');
              debugPrint('Stack trace: $stackTrace2');
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usar colores seguros con fallback
    final backgroundColor = Theme.of(context).colorScheme.tertiary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final textColor = Theme.of(context).colorScheme.onSecondary;

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
