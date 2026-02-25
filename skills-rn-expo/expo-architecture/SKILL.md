---
name: expo-architecture
description: Clean Architecture y feature-first en React Native con Expo.
license: Apache-2.0
metadata:
  scope: [react-native, expo, architecture]
  auto_invoke: "Capas, domain, data, presentation, feature-first"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-architecture – Clean Architecture en Expo

## Alcance

- Separación de capas: domain, data, presentation.
- Organización feature-first.
- Principios SOLID aplicados a módulos y dependencias.

## Capas por feature

Cada feature vive bajo `src/features/<feature>/` con:

| Capa | Contenido | Dependencias |
|------|-----------|--------------|
| **domain** | Entidades, interfaces de repositorio (contratos), tipos de dominio | Ninguna de UI ni de red; solo tipos puros |
| **data** | Implementación de repositorios, cliente API, mappers, DTOs | Puede depender de domain; no de componentes |
| **presentation** | Screens, componentes, hooks que usan repositorios/estado | Puede depender de domain y data vía hooks/DI |

- **Domain** no importa React ni Expo.
- **Data** implementa los contratos definidos en domain (interfaces).
- **Presentation** consume domain/data vía hooks o servicios inyectados; no debe llamar directamente a fetch/axios desde la UI.

## Estructura por feature

```
src/features/auth/
├── domain/
│   ├── entities.ts        # User, Session, etc.
│   ├── repositories.ts    # interfaces (IAuthRepository)
│   └── types.ts
├── data/
│   ├── api/
│   ├── mappers/
│   ├── repositories/      # AuthRepository impl
│   └── data.ts            # barrel
└── presentation/
    ├── screens/
    ├── components/
    ├── hooks/
    └── presentation.ts    # barrel
```

## Principios

- **Inversión de dependencias**: la UI depende de abstracciones (interfaces de repositorio), no de implementaciones concretas.
- **Un repositorio por dominio**: un contrato que agrupa todos los métodos de ese dominio (ej. `IAuthRepository`: login, logout, refresh).
- **Casos de uso (opcional)**: si la lógica es compleja, encapsular en funciones o clases “use case” que usen el repositorio; la pantalla llama al caso de uso, no al repositorio directo.

## Core compartido

- `src/core/`: config, cliente HTTP (ApiServices), almacenamiento seguro, logging, constantes. Detalle de qué va en core (ApiServices, config, env, servicios) en **expo-core**.
- Los features importan de `@core/` o `@/core`, no al revés. Core no importa de features.

## Cuándo usar este skill

- Definir o refactorizar la estructura de un feature.
- Decidir dónde colocar una entidad, un repositorio o un hook.
- Aplicar Clean Architecture en un proyecto Expo nuevo o existente.
