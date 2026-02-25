---
name: expo-ui
description: Componentes, tema, estilos (NativeWind/Tamagui) y accesibilidad en Expo.
license: Apache-2.0
metadata:
  scope: [react-native, expo, ui]
  auto_invoke: "Componentes, tema, estilos, accesibilidad"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-ui – UI y componentes en Expo

## Alcance

- Diseño de componentes reutilizables.
- Tema (colores, tipografía) y modo claro/oscuro.
- Estilos: StyleSheet, NativeWind (Tailwind) o Tamagui.
- Accesibilidad básica.

## Componentes

- Ubicación: `src/shared/ui/` para genéricos; `src/features/<feature>/presentation/components/` para los de un feature.
- Props tipadas con TypeScript; evitar `any`.
- Preferir composición (children, slots) sobre componentes monolíticos.
- Exportar desde un barrel (`index.ts`) cuando haya varios en la misma carpeta.

## Tema

- Centralizar colores y espaciado en `src/core/theme/` (objeto o tokens).
- Usar `useColorScheme()` de React Native o contexto de tema para claro/oscuro.
- Pasar colores vía contexto o props; evitar valores hardcodeados en cada pantalla.

## Estilos

- **StyleSheet**: para proyectos sin NativeWind; mantener estilos junto al componente o en un archivo `styles.ts` del feature.
- **NativeWind**: clases tipo Tailwind; configurar en `tailwind.config.js` y babel. Útil para iterar rápido y consistencia.
- **Tamagui**: sistema de diseño con temas y componentes; adecuado para apps más grandes con diseño unificado.

## Listas

- Para listas largas usar `FlashList` (@shopify/flash-list) o `FlatList` con `getItemLayout` si el tamaño es fijo.
- Evitar `ScrollView` con muchos hijos; ver **expo-performance**.

## Accesibilidad

- `accessibilityLabel` y `accessibilityHint` en botones e inputs.
- `accessibilityRole` (button, link, header, etc.).
- Probar con screen reader (TalkBack, VoiceOver).

## Buenas prácticas

1. Mantener pantallas delgadas: lógica en hooks, UI en componentes.
2. Evitar estilos inline para valores repetidos; usar tema o StyleSheet.
3. Componentes presentacionales sin llamadas API; datos vía props o hooks que usen repositorios.

## Cuándo usar este skill

- Crear o modificar pantallas y componentes.
- Definir o cambiar tema y estilos.
- Mejorar accesibilidad de la UI.
