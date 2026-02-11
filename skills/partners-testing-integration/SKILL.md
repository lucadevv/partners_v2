---
name: partners-testing-integration
description: >
  Agente de integration tests. Flujos E2E, app completa, integration_test.
  Invocar cuando: escribir o revisar integration tests para un feature o flujo.
metadata:
  author: partners-app
  version: "1.0"
  scope: [test]
  agent: integration-tests
  order: 3
---

# Integration tests (agente 3)

Responsabilidad: **solo integration tests (E2E)**. Orden en el flujo de testing: **3 (último)**.

## Cuándo usar este skill

- Escribir tests que arranquen la app real (`app.main()`) y simulen un flujo de usuario completo.
- Validar navegación, formularios, login → home, etc., con o sin backend mockeado.
- No sustituir unit ni widget tests; son complementarios.

## Ubicación de tests

- Carpeta **`integration_test/`** en la raíz del proyecto (convención Flutter).
- Ejemplo: `integration_test/auth_flow_test.dart`, `integration_test/transactions_flow_test.dart`.

```
integration_test/
├── app_launch_test.dart
├── auth_flow_test.dart
└── flows/
    └── ...
```

## Stack

- **integration_test**: `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`
- **flutter_test**: `testWidgets`, `tester`, `find`, `tap`, `enterText`, `pumpAndSettle`
- La app real: `import 'package:partners/main.dart' as app;` y `app.main()`

## Orden recomendado

Escribir integration tests **después** de unit y widget tests del feature (agentes 1 y 2).

## Flujo típico

1. `IntegrationTestWidgetsFlutterBinding.ensureInitialized();` al inicio de `main()`.
2. `app.main();` para arrancar la app.
3. `await tester.pumpAndSettle();` (o con timeout largo si hay animaciones/red).
4. Navegar (tap en “Login”, etc.), rellenar formularios, enviar.
5. Comprobar que se muestra la pantalla o mensaje esperado (`find.text`, `find.byType`).

## Consideraciones

- **Backend**: Si la app llama API real, usar entorno de test o mocks a nivel HTTP según convención del proyecto.
- **Tiempos**: `pumpAndSettle(Duration(seconds: 5))` si hay llamadas lentas.
- **Keys**: Usar `Key('...')` en widgets críticos para que los finds sean estables.
- **Datos sensibles**: No hardcodar credenciales reales; usar variables de entorno o fixtures de test.

## Comandos

```bash
# Ejecutar integration tests (si la app usa --dart-define, pasarlos también)
flutter test integration_test/

# Ejemplo con dart-define (token_mapbox, base_url, etc.)
flutter test integration_test/login_flow_test.dart \
  --dart-define=token_mapbox=TU_TOKEN \
  --dart-define=base_url=https://api.ejemplo.com
```

## Reglas

- Un file por flujo principal (ej. auth, checkout); agrupar casos en `group()`.
- Mensajes en español en `testWidgets()` y `group()` si el proyecto lo usa.
- Mantener los tests independientes (no depender del orden de ejecución).
