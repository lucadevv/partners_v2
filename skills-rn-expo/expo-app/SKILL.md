---
name: expo-app
description: Overview de proyectos React Native con Expo: estructura, comandos, SDK y buenas prácticas.
license: Apache-2.0
metadata:
  scope: [react-native, expo]
  auto_invoke: "Estructura de proyecto Expo, comandos, configuración"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-app – Proyecto React Native con Expo

## Alcance

- Estructura de carpetas recomendada para Expo (feature-first).
- Comandos de desarrollo, build y despliegue.
- Uso del SDK de Expo y gestión de dependencias.

## Estructura de proyecto (recomendada)

```
project/
├── app/                    # Expo Router: rutas file-based
│   ├── (tabs)/             # Grupo de tabs
│   ├── (auth)/             # Rutas de auth
│   ├── _layout.tsx         # Layout raíz
│   └── index.tsx           # Entrada
├── src/
│   ├── core/               # Config, servicios compartidos, utils
│   ├── features/           # Por feature (domain, data, presentation)
│   └── shared/             # Componentes/hooks compartidos
├── assets/
├── __tests__/
├── app.json
├── package.json
└── tsconfig.json
```

- **app/**: rutas con Expo Router; no mezclar lógica de negocio pesada aquí.
- **src/features/<feature>/**: domain, data, presentation por feature (ver **expo-architecture**).
- **src/core/**: configuración, cliente API, almacenamiento seguro, temas.

## Comandos esenciales

```bash
# Instalación
npm install
npx expo install

# Desarrollo
npx expo start
npx expo start --ios
npx expo start --android
npx expo start --tunnel

# Build (EAS)
eas build --platform android
eas build --platform ios
eas build --platform all

# Prebuild (generar android/ e ios/ si usas módulos nativos)
npx expo prebuild
```

## Dependencias

- Usar `npx expo install <paquete>` para dependencias compatibles con la versión del SDK.
- SDK de Expo: fijar en `app.json` / `app.config.js` (ej. `"sdkVersion": "52"`).

## Buenas prácticas

1. **TypeScript**: habilitar estricto en `tsconfig.json`.
2. **Alias**: configurar `@/` o `@core/`, `@features/` en `tsconfig` y babel/metro.
3. **Variables de entorno**: usar `expo-constants` con `extra` en `app.config.js` o `.env` con `expo-env`.
4. **No** poner lógica de negocio dentro de `app/`; delegar a hooks o servicios en `src/`.

## Cuándo usar este skill

- Crear o reorganizar un proyecto Expo.
- Dudas sobre comandos o estructura de carpetas.
- Integrar nuevas herramientas (EAS, CI) en el proyecto.
