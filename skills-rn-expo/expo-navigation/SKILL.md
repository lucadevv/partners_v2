---
name: expo-navigation
description: Navegación con Expo Router (file-based), stacks, tabs y protección de rutas.
license: Apache-2.0
metadata:
  scope: [react-native, expo, navigation]
  auto_invoke: "Rutas, tabs, stacks, guards, Expo Router"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-navigation – Navegación en Expo

## Alcance

- Expo Router (rutas file-based en `app/`).
- Grupos de rutas: (tabs), (auth), (stack).
- Redirección y protección de rutas (guards) según auth.

## Estructura típica (Expo Router)

```
app/
├── _layout.tsx            # Root layout (providers, theme)
├── index.tsx               # Redirige a /(tabs) o /(auth)/login
├── (tabs)/
│   ├── _layout.tsx        # Tab navigator
│   ├── index.tsx          # Home
│   └── profile.tsx
├── (auth)/
│   ├── _layout.tsx        # Stack sin tabs
│   ├── login.tsx
│   └── register.tsx
└── (stack)/                # Otras pantallas en stack
    └── detail/[id].tsx
```

- **Grupos** `(tabs)`, `(auth)`: no añaden segmento a la URL.
- **Rutas dinámicas**: `[id].tsx`, `[...slug].tsx`.

## Layout raíz

En `app/_layout.tsx`:

- Envolver con providers (estado global, tema, React Query).
- Cargar fuentes si usas `expo-font`.
- No poner lógica de negocio pesada; solo composición de layouts.

## Redirección según auth

- En el layout raíz o en `app/index.tsx`: leer estado de auth (Zustand, Context o AsyncStorage seguro).
- Si no autenticado y ruta protegida → `redirect` a `/(auth)/login`.
- Si autenticado y está en login → `redirect` a `/(tabs)`.
- Usar `<Redirect href="..." />` o `router.replace()` según el flujo.

## Navegación programática

```ts
import { router } from 'expo-router';

router.push('/detail/123');
router.replace('/(tabs)');
router.back();
```

## Buenas prácticas

1. Mantener `app/` solo para estructura de rutas y layouts; lógica en `src/features/`.
2. Rutas protegidas: comprobar auth en el layout del grupo o en un HOC/hook y redirigir.
3. Deep links: configurar `scheme` en `app.json` y manejar en `_layout` si aplica.

## Cuándo usar este skill

- Añadir o modificar pantallas y rutas.
- Implementar tabs o stacks.
- Proteger rutas según login/rol (guards).
