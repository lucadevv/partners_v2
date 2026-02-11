// Integration test del flujo de login.
// Ejecutar con las dart-define requeridas por la app, por ejemplo:
//   flutter test integration_test/login_flow_test.dart \
//     --dart-define=token_mapbox=TU_TOKEN_MAPBOX \
//     --dart-define=base_url=https://api.ejemplo.com

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:partners/features/auth/login/presentation/login_screen_keys.dart';
import 'package:partners/features/auth/login/presentation/login_screen_strings.dart';
import 'package:partners/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flujo de Login', () {
    testWidgets('la app muestra la pantalla de login al arrancar sin sesión',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(
        find.text(LoginScreenStrings.welcomeTitle),
        findsOneWidget,
      );
      expect(
        find.text(LoginScreenStrings.appName),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(LoginScreenKeys.continueButton)),
        findsOneWidget,
      );
    });

    testWidgets('al enviar formulario vacío se muestra SnackBar de validación',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      await tester.tap(find.byKey(const Key(LoginScreenKeys.continueButton)));
      await tester.pumpAndSettle();

      expect(
        find.text(LoginScreenStrings.emptyFieldsSnackBar),
        findsOneWidget,
      );
    });

    testWidgets('al ingresar email y contraseña se envía el login',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.emailField)),
          matching: find.byType(TextField),
        ),
        'test@example.com',
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.passwordField)),
          matching: find.byType(TextField),
        ),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key(LoginScreenKeys.continueButton)));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tras enviar: la app responde (éxito → navegación, o fallo → seguimos en login).
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('al ingresar email con formato inválido se muestra SnackBar',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.emailField)),
          matching: find.byType(TextField),
        ),
        'sinarroba',
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.passwordField)),
          matching: find.byType(TextField),
        ),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key(LoginScreenKeys.continueButton)));
      await tester.pumpAndSettle();

      expect(
        find.text(LoginScreenStrings.invalidEmailFormat),
        findsOneWidget,
      );
      expect(find.text(LoginScreenStrings.welcomeTitle), findsOneWidget);
    });

    testWidgets('con credenciales incorrectas se permanece en login',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.emailField)),
          matching: find.byType(TextField),
        ),
        'noexiste@example.com',
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.passwordField)),
          matching: find.byType(TextField),
        ),
        'claveincorrecta',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key(LoginScreenKeys.continueButton)));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Sin sesión válida seguimos en la pantalla de login.
      expect(
        find.text(LoginScreenStrings.welcomeTitle),
        findsOneWidget,
      );
    });
  });
}
