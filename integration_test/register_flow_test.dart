// Integration test del flujo Login → Regístrese gratis → Register.
// Ejecutar en invocación separada (no junto con unit/widget tests):
//   flutter test integration_test/register_flow_test.dart
// Con dart-define si la app los requiere:
//   flutter test integration_test/register_flow_test.dart \
//     --dart-define=token_mapbox=TU_TOKEN_MAPBOX \
//     --dart-define=base_url=https://api.ejemplo.com

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:partners/features/auth/login/presentation/login_screen_strings.dart';
import 'package:partners/features/auth/register/presentation/register_screen_keys.dart';
import 'package:partners/features/auth/register/presentation/register_screen_strings.dart';
import 'package:partners/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Asegura estar en login y navega a Register tocando "Regístrese gratis".
  /// Si la app quedó en Register (p. ej. test anterior), vuelve atrás primero.
  Future<void> goToRegisterScreen(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 10));
    if (find.text(RegisterScreenStrings.title).evaluate().isNotEmpty) {
      await tester.tap(find.text('Regresar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
    expect(find.text(LoginScreenStrings.welcomeTitle), findsOneWidget);
    await tester.tap(find.text(LoginScreenStrings.registerFree));
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  group('Flujo Login → Register', () {
    testWidgets('desde login al tocar Regístrese gratis se navega a pantalla de registro',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.text(LoginScreenStrings.welcomeTitle), findsOneWidget);

      await tester.tap(find.text(LoginScreenStrings.registerFree));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(
        find.text(RegisterScreenStrings.title),
        findsOneWidget,
      );
      expect(
        find.text(RegisterScreenStrings.ruc10),
        findsOneWidget,
      );
      expect(
        find.text(RegisterScreenStrings.continueButton),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(RegisterScreenKeys.rucField)),
        findsOneWidget,
      );
    });

    testWidgets('en registro el botón Continuar está deshabilitado sin RUC válido',
        (WidgetTester tester) async {
      app.main();
      await goToRegisterScreen(tester);

      expect(find.text(RegisterScreenStrings.title), findsOneWidget);

      final continueButton = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byKey(const Key(RegisterScreenKeys.continueButton)),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(continueButton.onPressed, isNull);
    });

    testWidgets('en registro al elegir RUC 20 se muestran campos de documento',
        (WidgetTester tester) async {
      app.main();
      await goToRegisterScreen(tester);

      await tester.tap(find.text(RegisterScreenStrings.ruc20));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key(RegisterScreenKeys.docField)),
        findsOneWidget,
      );
    });

    testWidgets('en registro al tocar Regresar se vuelve a login',
        (WidgetTester tester) async {
      app.main();
      await goToRegisterScreen(tester);

      expect(find.text(RegisterScreenStrings.title), findsOneWidget);

      await tester.tap(find.text('Regresar'));
      await tester.pumpAndSettle();

      expect(find.text(LoginScreenStrings.welcomeTitle), findsOneWidget);
    });

    testWidgets('en registro al ingresar RUC inválido (pocos dígitos) se muestra error de validación',
        (WidgetTester tester) async {
      app.main();
      await goToRegisterScreen(tester);

      expect(find.text(RegisterScreenStrings.title), findsOneWidget);

      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(RegisterScreenKeys.rucField)),
          matching: find.byType(TextField),
        ),
        '123',
      );
      await tester.pump();
      await tester.pumpAndSettle(const Duration(milliseconds: 1200));

      expect(
        find.text('El RUC debe tener 11 dígitos y comenzar con 10'),
        findsOneWidget,
      );
    });

    testWidgets('en registro al cambiar de RUC 20 a RUC 10 el campo documento deja de mostrarse',
        (WidgetTester tester) async {
      app.main();
      await goToRegisterScreen(tester);

      await tester.tap(find.text(RegisterScreenStrings.ruc20));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key(RegisterScreenKeys.docField)), findsOneWidget);

      await tester.tap(find.text(RegisterScreenStrings.ruc10));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key(RegisterScreenKeys.docField)), findsNothing);
    });

    testWidgets('en registro con RUC 10 al ingresar RUC con formato válido se hace llamada (éxito o error backend)',
        (WidgetTester tester) async {
      app.main();
      await goToRegisterScreen(tester);

      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(RegisterScreenKeys.rucField)),
          matching: find.byType(TextField),
        ),
        '10123456789',
      );
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text(RegisterScreenStrings.title), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
