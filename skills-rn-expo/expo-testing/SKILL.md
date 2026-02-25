---
name: expo-testing
description: Tests en Expo: Jest, React Native Testing Library y E2E (Detox/Maestro).
license: Apache-2.0
metadata:
  scope: [react-native, expo, testing]
  auto_invoke: "Tests unitarios, componentes, E2E"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-testing – Testing en Expo

## Alcance

- Tests unitarios: Jest para lógica pura, mappers, repositorios (con mocks).
- Tests de componentes: React Native Testing Library (RTL).
- Tests E2E: Detox o Maestro con app en modo release o development build.

## Jest (unit)

- Configuración: `jest.config.js` o en `package.json`; preset `jest-expo` para RN.
- Mocks: `jest.mock()` para módulos (API, SecureStore, navegación).
- Repositorios y mappers: tests sin renderizar; inyectar dependencias mock.
- Cubrir casos de éxito, error y edge cases en la lógica de negocio.

## React Native Testing Library

- Renderizar componentes con `render()`; consultar por `getByRole`, `getByLabelText`, `getByTestId` (testID).
- Disparar eventos: `fireEvent` o `userEvent` si se usa.
- Evitar detalles de implementación; priorizar comportamiento y accesibilidad.
- Para hooks: usar `renderHook` de `@testing-library/react-hooks` o envolver en un componente mínimo.

## E2E (Detox / Maestro)

- **Detox**: requiere build de prueba (ej. `detox build`); configurar en `.detoxrc.js`. Útil para flujos críticos (login, compra).
- **Maestro**: scripts YAML que ejecutan contra la app instalada; más simple de integrar en CI.
- Ejecutar contra un build de desarrollo o release; no depender de Metro en E2E.

## Estructura

- `__tests__/` junto al código o en una carpeta `__tests__/` por feature.
- `__tests__/unit/`, `__tests__/components/`, `e2e/` para E2E.
- Nombres: `*.test.ts(x)` o `*.spec.ts(x)` según convención del proyecto.

## Buenas prácticas

1. Mockear dependencias externas (API, SecureStore, router).
2. Tests de presentación: probar que al pulsar un botón se llama a la acción esperada (mock del hook o del repositorio).
3. E2E: pocos tests, flujos críticos; mantenerlos estables (selectors por testID o accesibilidad).

## Cuándo usar este skill

- Escribir o modificar tests unitarios o de componentes.
- Configurar Jest o RTL.
- Añadir o mantener tests E2E.
