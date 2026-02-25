---
name: expo-performance
description: Optimización en Expo: listas, memo, re-renders y bundle.
license: Apache-2.0
metadata:
  scope: [react-native, expo, performance]
  auto_invoke: "Rendimiento, listas, FlashList, memo, re-renders"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-performance – Rendimiento en Expo

## Alcance

- Listas largas: FlatList, FlashList, virtualización.
- Evitar re-renders innecesarios: React.memo, useMemo, useCallback.
- Imágenes: optimización y caché.
- Bundle size y lazy loading de pantallas.

## Listas

- **FlashList** (@shopify/flash-list): reemplazo de FlatList con mejor rendimiento; usar `estimatedItemSize` cuando sea posible.
- **FlatList**: si no usas FlashList, usar `getItemLayout` cuando los ítems tienen altura fija para evitar mediciones.
- Evitar `ScrollView` con `.map()` de muchos elementos; siempre virtualizar con FlatList/FlashList o similar.
- `keyExtractor` estable (id único); evitar index como key si el orden cambia.

## Re-renders

- **React.memo** en componentes que reciben props que cambian poco; evita re-render si las props son iguales (shallow).
- **useMemo**: para valores derivados costosos (filtrados, ordenaciones) que se usan como dependencias o en JSX.
- **useCallback**: para funciones pasadas a hijos que están memoizados, para que la referencia no cambie en cada render.
- No abusar: medir antes; priorizar componentes que renderizan muchos hijos o que están en listas.

## Imágenes

- `expo-image`: caché y prioridad de carga; preferir sobre `Image` de RN para listas.
- Tamaños adecuados (no cargar full-res para thumbnails); usar `contentFit` y dimensiones razonables.

## Código y bundle

- Lazy de pantallas: `React.lazy` + `Suspense` para rutas poco usadas (Expo Router puede hacer lazy por ruta según configuración).
- Revisar dependencias pesadas; importar solo lo necesario (tree-shaking con ESM).
- Analizar bundle con `npx expo export` y herramientas de análisis (ej. source-map-explorer) si aplica.

## Herramientas

- React DevTools Profiler para ver qué componentes se re-renderizan.
- Flipper o React Native Performance Monitor para FPS y uso de memoria en desarrollo.

## Cuándo usar este skill

- Listas con muchos ítems o scroll con tirones.
- Optimizar pantallas con muchos componentes.
- Reducir tiempo de arranque o tamaño del bundle.
