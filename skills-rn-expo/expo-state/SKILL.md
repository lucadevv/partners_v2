---
name: expo-state
description: Estado global (Zustand/Redux), estado local y formularios en React Native con Expo.
license: Apache-2.0
metadata:
  scope: [react-native, expo, state]
  auto_invoke: "Estado global, Zustand, formularios, hooks"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-state – Gestión de estado en Expo

## Alcance

- Estado global: Zustand (recomendado) o Redux.
- Estado local: `useState`, `useReducer`.
- Estado de servidor: React Query o SWR (ver **expo-data**).
- Formularios: React Hook Form + Zod (o similar).

## Estado global (Zustand)

- Un store por dominio (auth, cart, ui) o un store raíz con slices.
- Mantener stores fuera de la UI: la pantalla solo lee y dispara acciones.

Ejemplo mínimo:

```ts
// src/core/stores/auth-store.ts
import { create } from 'zustand';

interface AuthState {
  token: string | null;
  setToken: (t: string | null) => void;
}
export const useAuthStore = create<AuthState>((set) => ({
  token: null,
  setToken: (token) => set({ token }),
}));
```

- No poner llamadas API directas en el store; usar servicios inyectados o hooks que llamen al repositorio y luego actualicen el store.

## Estado local

- `useState` para UI local (modales, inputs controlados).
- `useReducer` si la lógica de actualización es compleja en una pantalla.
- Evitar estado global para lo que solo usa un componente o una pantalla.

## Formularios

- React Hook Form + Zod (validación) para formularios con varios campos.
- Valores por defecto y `reset` desde datos del servidor cuando aplique.
- No usar estado global para cada campo; RHF maneja el estado del form.

## Sincronización con servidor

- Datos que vienen del API: React Query (TanStack Query) o SWR.
- El estado global (Zustand) para auth, preferencias, carrito; React Query para listas y detalles que se cachean y revalidan.

## Buenas prácticas

1. Un solo origen de verdad por dato: no duplicar en store y en React Query sin criterio.
2. Acciones asíncronas: hacerlas en hooks o servicios; el store solo recibe el resultado (ej. setToken después de login).
3. Persistencia: usar `zustand/middleware` persist para lo que deba sobrevivir al cierre de la app (ej. token en SecureStore detrás del middleware).

## Cuándo usar este skill

- Crear o modificar stores (Zustand/Redux).
- Decidir si un estado debe ser global o local.
- Implementar o refactorizar formularios.
