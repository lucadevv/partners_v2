---
name: expo-di
description: Inyección de dependencias en React Native con Expo: Context, tsyringe o módulos.
license: Apache-2.0
metadata:
  scope: [react-native, expo, dependency-injection]
  auto_invoke: "Inyección de dependencias, providers, servicios"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-di – Inyección de dependencias en Expo

## Alcance

- Proveer repositorios, cliente API y servicios a la capa de presentación sin acoplamiento directo.
- Patrones: React Context, tsyringe (u otro contenedor) o módulos con factories.

## Opción 1: React Context

- Un `Provider` por “módulo” (ej. ApiProvider, AuthProvider) que instancia el cliente o repositorio y lo expone vía `useContext`.
- Crear el cliente/repositorio una vez (en el provider) y pasarlo a los hijos.
- Útil para proyectos pequeños o medios; evita prop drilling.

## Opción 2: Contenedor (tsyringe, inversify)

- Registrar interfaces → implementaciones en el arranque (ej. en `App.tsx` o en un `setup.ts`).
- En componentes/hooks: resolver con `container.resolve(IAuthRepository)` o un hook `useAuthRepository()` que haga el resolve.
- Ventaja: testing fácil con mocks registrados en el contenedor.

## Opción 3: Módulos / factories

- En `src/core/` o por feature: exportar funciones que devuelven la instancia (singleton o nueva según el caso).
- Ejemplo: `getAuthRepository(): IAuthRepository` que internamente usa el cliente API ya configurado.
- La presentación importa y llama a `getAuthRepository()`; en tests se puede mockear el módulo.

## Recomendación

- Proyectos Expo típicos: empezar con **Context** para API client y auth; añadir contenedor si crece la cantidad de dependencias y se necesita mejor testabilidad.
- Siempre depender de **abstracciones** (interfaces) en la capa de presentación; no de clases concretas de la capa data.

## Testing

- Con Context: envolver el árbol en un provider con implementaciones mock.
- Con tsyringe: registrar mocks antes del test y limpiar después.
- Con módulos: jest.mock del módulo que exporta el repositorio.

## Cuándo usar este skill

- Configurar o refactorizar cómo se inyectan repositorios y servicios.
- Añadir un nuevo servicio compartido (ej. analytics, storage).
- Mejorar testabilidad con mocks.
