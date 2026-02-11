---
name: partners-testing-widget
description: >
  Agente de widget tests. Pantallas, widgets, componentes con pumpWidget y find.
  Invocar cuando: escribir o revisar widget tests para un feature.
metadata:
  author: partners-app
  version: "1.0"
  scope: [test]
  agent: widget-tests
  order: 2
---

# Widget tests (agente 2)

Responsabilidad: **solo widget tests**. Orden en el flujo de testing: **2 (después de unit tests)**.

## Cuándo usar este skill

- Escribir tests que rendericen widgets (pantallas, componentes, formularios).
- Verificar que la UI muestra lo correcto, reacciona a taps e inputs y muestra errores/loading.
- No probar flujos E2E completos con app real; para eso usar el agente de integration tests.

## Ubicación de tests

Estructura **espejo del feature** bajo `test/`:

```
test/features/<feature>/
└── presentation/
    ├── screens/
    │   └── <name>_screen_test.dart
    └── widgets/
        └── <name>_widget_test.dart
```

## Stack

- **flutter_test**: `testWidgets()`, `WidgetTester`, `pumpWidget()`, `pump()`, `pumpAndSettle()`, `find`, `tap()`, `enterText()`
- **mocktail**: mocks del Cubit/Bloc o Notifier que inyectes en la pantalla
- **BlocProvider** / **RepositoryProvider**: envolver la pantalla con el cubit mockeado

## Orden recomendado

Escribir widget tests **después** de los unit tests del mismo feature (agente 1).

## Keys y constantes de texto (precisión)

Para que los widget tests sean **precisos y mantenibles**:

### Clase de Keys (en `lib/`)

- Crear una clase con constantes de key para la pantalla, por ejemplo `XxxScreenKeys` en `lib/features/<feature>/presentation/xxx_screen_keys.dart`.
- Usar `Key(XxxScreenKeys.emailField)` etc. en los widgets de la pantalla (campos, botón principal, enlaces).
- En los tests: `find.byKey(const Key(XxxScreenKeys.continueButton))`, y para campos con hijo `TextField`: `find.descendant(of: find.byKey(Key(XxxScreenKeys.emailField)), matching: find.byType(TextField))`.
- Ventaja: el test no depende de orden de widgets ni de `find.text` para interacción; los keys son estables.

### Clase de textos (en `lib/`, compartida con la UI)

- La **misma** clase que usa la pantalla para sus textos fijos (véase skill **partners-ui**: "Textos fijos"). Por ejemplo `XxxScreenStrings` en `lib/features/<feature>/presentation/xxx_screen_strings.dart`.
- La UI usa `Text(XxxScreenStrings.welcomeTitle)` etc.; los tests importan esa clase y usan `expect(find.text(XxxScreenStrings.welcomeTitle), findsOneWidget)` y `find.text(XxxScreenStrings.emptyFieldsSnackBar)` para SnackBars.
- **No** duplicar textos en una clase solo de test: una sola fuente de verdad en lib.

### Resumen

- **Keys** (en lib, usados por pantalla y test): para localizar widgets de forma estable; preferir `find.byKey` para taps y `enterText` en campos.
- **Textos** (en lib, clase compartida con la UI): usar `XxxScreenStrings`; evitar strings literales en los asserts y en la UI.

## Pantallas (screens)

- Crear un **Mock del Cubit** que usa la pantalla: `class MockXxxCubit extends MockCubit<XxxState> implements XxxCubit {}`
- Envolver con `BlocProvider<XxxCubit>.value(value: mockCubit)` y `MaterialApp` (y `Scaffold` si hace falta).
- Configurar estado con **whenListen** (bloc_test): `whenListen(mockCubit, Stream.fromIterable([state]), initialState: state)`.
- Probar: presencia de textos con la clase de la UI (`find.text(XxxScreenStrings.xxx)`), botones/campos con keys (`find.byKey(Key(XxxScreenKeys.xxx))`).
- Probar interacción: `enterText` en el descendant TextField del key del campo, `tap(find.byKey(Key(XxxScreenKeys.continueButton)))`, luego `pumpAndSettle()` y `verify(() => mockCubit.metodo(...)).called(1)`.

## Widgets aislados

- Sin Cubit si el widget es presentacional; pasar callbacks o datos por parámetro.
- Envolver en `MaterialApp` (y `Scaffold` si usa tema/context).
- Probar texto, tap en botones, estado disabled/loading si aplica.

## Reglas

- Un test file por pantalla o widget relevante; nombre `*_test.dart`.
- **Keys**: definir una clase de keys en lib (ej. `LoginScreenKeys`) y usarla en la pantalla y en los tests; usar `find.byKey` para botones y campos.
- **Textos**: usar la misma clase de strings que la UI (en lib, ej. `LoginScreenStrings`); no duplicar en test ni usar strings literales en `find.text` ni en `expect`.
- Evitar dependencias reales (API, DB); todo inyectado y mockeado.
- Mensajes en español en `testWidgets()` si el proyecto lo usa.
