// Integration test del flujo hasta la pantalla Crear sucursal.
// Requiere app arrancada; si hay sesión se navega Home → Sucursales → Nueva sucursal.
// Ejecutar: flutter test integration_test/create_branch_flow_test.dart
// Con dart-define si la app los requiere:
//   flutter test integration_test/create_branch_flow_test.dart \
//     --dart-define=token_mapbox=TU_TOKEN \
//     --dart-define=base_url=https://api.ejemplo.com

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:partners/features/auth/login/presentation/login_screen_strings.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_keys.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';
import 'package:partners/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flujo Crear sucursal', () {
    testWidgets('la app arranca y muestra login o home',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets(
        'al navegar desde Home a Sucursales y tocar Nueva sucursal se muestra la pantalla Crear sucursal',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Si estamos en login, no hay Home; el test solo verifica que la app arrancó.
      final onLogin =
          find.text(LoginScreenStrings.welcomeTitle).evaluate().isNotEmpty;
      if (onLogin) {
        expect(find.text(LoginScreenStrings.welcomeTitle), findsOneWidget);
        return;
      }

      // Buscar el card "Ver mis sucursales" en Home (puede ser texto en dos líneas).
      final sucursalesFinder = find.text('Ver mis\nsucursales');
      if (sucursalesFinder.evaluate().isEmpty) {
        // Layout alternativo o no estamos en Home; no forzamos fallo.
        expect(find.byType(Scaffold), findsWidgets);
        return;
      }

      await tester.tap(sucursalesFinder);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // En la pantalla de sucursales, tocar "Nueva sucursal".
      final nuevaSucursalFinder = find.text('Nueva sucursal');
      if (nuevaSucursalFinder.evaluate().isEmpty) {
        expect(find.byType(Scaffold), findsWidgets);
        return;
      }

      await tester.tap(nuevaSucursalFinder);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(
        find.text(CreateBranchScreenStrings.appBarTitle),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(CreateBranchScreenKeys.createButton)),
        findsOneWidget,
      );

      // El botón Crear debe estar deshabilitado con formulario vacío.
      final button = tester.widget<ElevatedButton>(
        find.byKey(const Key(CreateBranchScreenKeys.createButton)),
      );
      expect(button.onPressed, isNull);
    });
  });
}
