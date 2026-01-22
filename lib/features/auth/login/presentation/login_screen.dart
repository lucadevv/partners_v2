import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/utils/widgets/custom_text_field_widget.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              right: -400,
              bottom: -140,
              child: Transform.scale(
                scale: 1.1,
                child: Image.asset('assets/png/person.png', fit: BoxFit.cover),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: AlignmentGeometry.topCenter,
                  colors: [
                    context.appColor.primary.withValues(alpha: 0.84),
                    Colors.transparent,
                  ],
                  stops: [0.4, 1.0],
                ),
              ),
              child: SizedBox.expand(),
            ),
            Positioned(
              bottom: 30,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: -8,
                      children: [
                        Text(
                          "¡Bienvenido a",
                          style: TextStyle(
                            color: context.appColor.onPrimary,
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Partners",
                          style: TextStyle(
                            color: context.appColor.onPrimary,
                            fontSize: 30,
                            fontFamily: 'FREDOKA',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SvgPicture.asset('assets/svg/logo.svg'),
                      ],
                    ),
                    Text(
                      "Ingrese colocando sus datos",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.appColor.onPrimary,
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.appColor.onSecondary.withValues(
                          alpha: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 20,
                          children: [
                            CustomTextFieldWidget(
                              label: "Email",
                              hintText: "Ingrese su correo electrónico",
                              keyboardType: TextInputType.emailAddress,
                            ),
                            CustomTextFieldWidget(
                              label: "Contraseña",
                              hintText: "Ingrese su contraseña",
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runAlignment: WrapAlignment.center,
                                alignment: WrapAlignment.center,
                                runSpacing: 8,
                                spacing: 8,
                                children: [
                                  Icon(Icons.arrow_right_alt_outlined),
                                  Text(
                                    "Continuar",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                SvgPicture.asset('assets/svg/locked.svg'),
                                Text("¿Olvidó su contraseña?"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: -10,
                      children: [
                        Icon(
                          Icons.person_2_outlined,
                          color: context.appColor.onPrimary,
                        ),
                        Text(
                          '¿No tiene cuenta?',
                          style: TextStyle(
                            color: context.appColor.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ),
                          onPressed: () {
                            context.router.push(RegisterRoute());
                          },
                          child: Text(
                            'Regístrese gratis',
                            style: TextStyle(
                              color: context.appColor.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
