# Guía para React Native con Expo

## Cómo usar esta guía

- Este documento es el **orquestador** para proyectos **React Native con Expo**.
- Nombres y skills: prefijo **expo-** y carpeta **skills-rn-expo/**.
- Cada **skill** en `skills-rn-expo/` tiene patrones por dominio. Cuando la tarea coincida con la tabla **Auto-invoke Skills**, invocar ese skill PRIMERO (leer `skills-rn-expo/<nombre>/SKILL.md`).

## Available Skills (React Native / Expo)

Todos los skills son **genéricos**: aplican a cualquier proyecto Expo, no a una app concreta (p. ej. auth es “login, tokens, SecureStore” en general; core es “ApiServices, config, servicios compartidos” en general). Usar bajo demanda; si un skill no existe aún, seguir esta guía y la sección Code Style.

### Skills genéricos (cualquier proyecto Expo)

| Skill | Descripción | URL |
|-------|-------------|-----|
| `expo-app` | Overview Expo, estructura, comandos, SDK | [SKILL.md](skills-rn-expo/expo-app/SKILL.md) |
| `expo-architecture` | Clean Architecture, feature-first, capas | [SKILL.md](skills-rn-expo/expo-architecture/SKILL.md) |
| `expo-core` | ApiServices (cliente HTTP), config, env, servicios compartidos | [SKILL.md](skills-rn-expo/expo-core/SKILL.md) |
| `expo-navigation` | Expo Router (file-based), stacks, tabs, guards | [SKILL.md](skills-rn-expo/expo-navigation/SKILL.md) |
| `expo-state` | Estado global (Zustand/Redux), estado local, formularios | [SKILL.md](skills-rn-expo/expo-state/SKILL.md) |
| `expo-data` | Repositorios, React Query/SWR, mappers (consumen cliente de core) | [SKILL.md](skills-rn-expo/expo-data/SKILL.md) |
| `expo-di` | Inyección de dependencias (context, tsyringe, módulos) | [SKILL.md](skills-rn-expo/expo-di/SKILL.md) |
| `expo-ui` | Componentes, tema, NativeWind/Tamagui, accesibilidad | [SKILL.md](skills-rn-expo/expo-ui/SKILL.md) |
| `expo-auth` | Auth, tokens, secure storage, refresh | [SKILL.md](skills-rn-expo/expo-auth/SKILL.md) |
| `expo-testing` | Jest, React Native Testing Library, E2E (Detox/Maestro) | [SKILL.md](skills-rn-expo/expo-testing/SKILL.md) |
| `expo-performance` | Listas (FlashList), memo, lazy loading, re-renders | [SKILL.md](skills-rn-expo/expo-performance/SKILL.md) |

### Auto-invoke Skills

Al realizar estas acciones, invocar el skill correspondiente PRIMERO:

| Acción | Skill |
|--------|-------|
| Crear o modificar estructura del proyecto / features | `expo-app` |
| Definir o refactorizar capas (domain, data, presentation) | `expo-architecture` |
| Cliente HTTP (ApiServices), config, env, servicios de core | `expo-core` |
| Añadir o cambiar rutas, tabs, stacks, protección de rutas | `expo-navigation` |
| Gestionar estado global o estado de formularios | `expo-state` |
| Repositorios, mappers, caché (React Query/SWR) | `expo-data` |
| Configurar o usar inyección de dependencias | `expo-di` |
| Crear/modificar pantallas, componentes, tema, estilos | `expo-ui` |
| Flujos de login, tokens, almacenamiento seguro | `expo-auth` |
| Escribir tests unitarios, de componentes o E2E | `expo-testing` |
| Optimizar listas, re-renders, bundle size | `expo-performance` |

---

## Project Overview (Expo)

Proyecto tipo: app React Native con **Expo**, **arquitectura limpia** y **feature-first**.

| Capa | Ubicación típica | Stack |
|------|------------------|-------|
| Domain | `src/features/<feature>/domain/` | Entidades, interfaces de repositorio, casos de uso (si se usan) |
| Data | `src/features/<feature>/data/` | Repositorios, APIs, mappers, modelos |
| Presentation | `src/features/<feature>/presentation/` o `app/` (Expo Router) | Screens, componentes, hooks |
| Core | `src/core/` | ApiServices (cliente HTTP), config, env, servicios compartidos (ver **expo-core**) |
| Tests | `__tests__/`, `e2e/` | Unit, component, E2E |

- **Expo Router**: rutas file-based en `app/` (ej. `app/(tabs)/index.tsx`, `app/(auth)/login.tsx`).
- **Estado**: Zustand o Redux para global; `useState`/`useReducer` para local; React Query/SWR para servidor.
- **Estilos**: NativeWind (Tailwind), StyleSheet, o Tamagui según el proyecto.

---

## Desarrollo (Expo)

```bash
# Setup
npm install
npx expo install

# Desarrollo
npx expo start
npx expo start --ios
npx expo start --android

# Build
npx expo prebuild
eas build --platform all

# Tests
npm test
npm run test:e2e
```

---

## Code Style (React Native / Expo)

- **Naming**: archivos en `kebab-case` o `PascalCase` para componentes; carpetas en `kebab-case`. Constantes `UPPER_SNAKE_CASE`.
- **Componentes**: preferir componentes funcionales y hooks; export nombrado para componentes.
- **Tipos**: TypeScript estricto; interfaces para props y modelos.
- **Imports**: agrupar: React/React Native, terceros, alias `@/` o relativos del proyecto.
- **Estado**: no poner lógica de negocio en `useState`; usar stores (Zustand) o servicios inyectados.
- **Accesibilidad**: `accessibilityLabel`, `accessibilityHint` donde aplique.

---

## Commit y PR

**Conventional commits**: `feat:`, `fix:`, `docs:`, `chore:`, `perf:`, `refactor:`, `style:`, `test:`.

Antes del PR:

1. `npm run lint` (o `expo lint`).
2. `npm test`.
3. Probar en iOS y Android cuando sea posible.

---

## Stack (React Native + Expo)

| Aspecto | En este proyecto |
|---------|------------------|
| Skills | `skills-rn-expo/`, prefijo `expo-` |
| Navegación | Expo Router (file-based) o React Navigation |
| Estado | Zustand/Redux, hooks, React Query/SWR |
| DI | Context, tsyringe o módulos |
| UI | Components, NativeWind/Tamagui/StyleSheet |
| Tests | Jest, React Native Testing Library, Detox/Maestro |
