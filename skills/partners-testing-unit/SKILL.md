---
name: partners-testing-unit
description: >
  Agente de tests unitarios. Use cases, Cubits, repositorios, mappers.
  Invocar cuando: escribir o revisar unit tests para un feature.
metadata:
  author: partners-app
  version: "1.0"
  scope: [test]
  agent: unit-tests
  order: 1
---

# Unit tests (agente 1)

Responsabilidad: **solo tests unitarios**. Orden en el flujo de testing: **1 (primero)**.

## Cuándo usar este skill

- Escribir tests para Use Cases, Cubits, repositorios (impl), mappers, datasources.
- Revisar o ampliar tests unitarios de un feature.
- No incluir UI ni `pumpWidget`; solo lógica aislada con mocks.

## Ubicación de tests

Estructura **espejo del feature** bajo `test/`:

```
test/features/<feature>/
├── domain/
│   └── use_case/
│       └── <name>_usecase_test.dart
├── data/
│   ├── repository/
│   │   └── <name>_repository_impl_test.dart
│   ├── datasource/
│   └── mappers/
└── presentation/
    └── cubit/
        └── <name>_cubit_test.dart
```

## Stack

- **flutter_test**: `test()`, `group()`, `setUp()`, `setUpAll()`
- **mocktail**: `Mock`, `when()`, `verify()`, `any()`, `registerFallbackValue()` para tipos usados en `any()`
- **bloc_test**: `blocTest<Cubit, State>()` para Cubits
- **dartz**: `Either` (Right/Left) en resultados de use case/repository

## Orden recomendado al escribir tests de un feature

1. **Domain**: Use Case (mock del Repository).
2. **Data**: Repository impl (mock de DataSources), mappers si aplica.
3. **Presentation**: Cubit (mock del Use Case).

## Use Case

- Mock del **repository** (interfaz de dominio).
- `when(() => mockRepo.metodo(any())).thenAnswer((_) async => Right(entity) | Left(exception))`.
- `expect(result, Right(tEntity))` o `expect(result, const Left(tFailure))`.
- `registerFallbackValue(Entity(...))` en `setUpAll` si usas `any()` con ese tipo.

## Cubit

- Mock del **use case** (no del repository).
- Estado inicial: `expect(cubit.state, const XxxState(...))`.
- `blocTest`: `build` (crear cubit y configurar when del use case), `act`, `expect` (lista de estados), `verify` opcional.
- Para “no doble llamada en loading”: usar `Completer().future` en el mock y `verify(...).called(1)`.

## Repository impl

- Mock de **datasources** y/o mappers.
- Probar que se llama al datasource correcto y se mapea a entidad o se devuelve Left en error.

## Reglas

- Un test file por clase bajo test; nombre `*_test.dart`.
- No depender de otros tests; cada test aislado con sus mocks.
- Mensajes en español en `test()` y `group()` si el proyecto lo usa.
