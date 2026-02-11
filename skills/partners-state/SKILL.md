---
name: partners-state
description: >
  BLoC/Cubit and ChangeNotifier for Partners. Fold of Either only in Cubit (reference: auth/register).
  Trigger: Creating or modifying Cubit, BLoC, or Notifier; form state.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [presentation]
  auto_invoke:
    - "Creating BLoC or Cubit classes"
    - "Creating or modifying Notifiers (ChangeNotifier)"
    - "Handling result.fold or Either in presentation"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Regla principal: el fold solo va en el Cubit

- El **UseCase** (domain) retorna `Future<Either<AppException, T>>` y puede hacer validaciones de dominio devolviendo `Left`. **Nunca** hace `fold`.
- El **Cubit** es el único lugar donde se hace `response.fold(...)`: interpretar failure/success y emitir estados. Referencia: `auth/register` (`RegisterCubit`, `LoginCubit`).

## File Conventions

```
lib/features/<feature>/presentation/
├── cubit/
│   ├── feature_cubit.dart      # Cubit: aquí va el fold
│   └── feature_state.dart      # State (o part of cubit)
├── notifier/
│   └── feature_form_notifier.dart
├── screens/
└── widgets/
```

## Patrón Cubit (referencia: RegisterCubit)

1. **Guard** de loading: si ya está en loading, no disparar de nuevo.
2. **Emit loading**: `emit(state.copyWith(xxxStatus: Status.loading))`.
3. **Llamar UseCase**: `final response = await _useCase.call(...)`.
4. **Fold solo en el Cubit**: en `failure` emitir error con `getErrorMessage(failure)`; en `success` emitir éxito y efectos opcionales (ej. guardar sesión).

Usar `BaseCubitMixin` cuando exista en el proyecto para `getErrorMessage(failure)`.

```dart
// RegisterCubit (auth/register): el fold está solo en el Cubit
Future<void> sendRuc({required String ruc, required RucType type}) async {
  if (state.sendRucStatus == RegisterStatus.loading) return;
  emit(state.copyWith(sendRucStatus: RegisterStatus.loading));

  final response = await _sendRucUsecase.call(type: type, ruc: ruc);

  await response.fold(
    (failure) async {
      String errorMessage = getErrorMessage(failure);  // BaseCubitMixin
      emit(state.copyWith(
        sendRucStatus: RegisterStatus.failure,
        errorMessage: errorMessage,
      ));
    },
    (responseEntity) async {
      emit(state.copyWith(
        sendRucStatus: RegisterStatus.success,
        rucData: responseEntity,
      ));
      _sessionStorage.saveSessionId(responseEntity.sessionId);  // efecto secundario
    },
  );
}
```

## Cuando usar Cubit vs Notifier

| Responsabilidad | Dónde | Ejemplo |
|-----------------|--------|---------|
| **Cubit** | Flujos async, llamada a UseCase, **fold** del Either, emit success/failure | `RegisterCubit`, `LoginCubit` |
| **Notifier** | Formularios complejos: controllers, validación de campos, errores por campo. No hace fold ni llama UseCase directo; puede llamar a un Cubit al enviar | `RegisterFormNotifier` |

- Cubit: depende de UseCases (domain). No depende de RepositoryImpl ni DataSource.
- Notifier: controllers, `notifyListeners()`, `dispose()` de controllers. Al enviar el formulario suele llamar `context.read<XxxCubit>().submit(...)`.

## AutoRoute + Cubit/Bloc (referencia: .cursor/rules/arquiecture.mdc)

- Cualquier pantalla que use **BlocProvider** (o Cubit inyectado) con **AutoRoute** debe implementar **AutoRouteWrapper**.
- En la pantalla: `class XxxScreen extends StatelessWidget implements AutoRouteWrapper`.
- Implementar `wrappedRoute(BuildContext context)`: crear el Cubit (p. ej. `getIt<XxxCubit>()`), llamar al método de carga inicial si aplica, devolver `BlocProvider(create: (_) => cubit, child: this)`.
- No poner un segundo `BlocProvider` dentro de `build`; el provider queda solo en `wrappedRoute`.

## RefreshIndicator y botón Reintentar (referencia: .cursor/rules/arquiecture.mdc)

- En pantallas con **lista/grid/scroll** de datos obtenidos por UseCase/Cubit: el contenido desplazable debe ir dentro de **RefreshIndicator**. `onRefresh` debe llamar al método del Cubit que recarga (p. ej. `context.read<XxxCubit>().loadXxx()`) y devolver el `Future` de ese método.
- Botón **"Reintentar"** / **"Retry"** o icono de recarga: debe ejecutar el **mismo método de carga** del Cubit (un solo método usado por RefreshIndicator y por Reintentar).

## Resumen

| Qué | Dónde | Regla |
|-----|--------|--------|
| Validaciones de dominio (ej. RUC inválido) | UseCase (domain) | `return Left(ValidationException(...))` |
| **fold** del resultado del UseCase | **Solo en Cubit** | `response.fold((f) => emit(failure), (s) => emit(success))` |
| Mensaje de error para el usuario | Cubit | `getErrorMessage(failure)` (ej. BaseCubitMixin) |
| UI | partners-ui | Solo `context.read<Cubit>().method()` y estado; nunca fold ni UseCase |
| Pantalla con Cubit + AutoRoute | Pantalla | Implementar AutoRouteWrapper, BlocProvider en wrappedRoute |
| Lista con datos remotos | Pantalla | RefreshIndicator + mismo método para Reintentar |
