---
name: expo-core
description: Capa core en Expo: ApiServices (cliente HTTP), config, env, servicios compartidos, logging y manejo de errores.
license: Apache-2.0
metadata:
  scope: [react-native, expo, core]
  auto_invoke: "ApiServices, cliente HTTP, config, core, servicios compartidos"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-core – Capa core en Expo

## Alcance

- **Cliente HTTP (ApiServices)**: instancia única, base URL, interceptors, timeout y manejo de errores.
- **Config y variables de entorno**: base URL, feature flags, constantes de app.
- **Servicios compartidos**: storage (AsyncStorage / SecureStore), logging, analítica, manejo de errores global.
- Todo de forma **genérica** para cualquier app Expo; sin asumir flujos de negocio concretos.

## Ubicación

- `src/core/` (o `core/` en la raíz).
- Subcarpetas sugeridas: `api/`, `config/`, `services/`, `utils/`, `constants/`.

## ApiServices / Cliente HTTP

- **Un solo cliente** para toda la app (singleton o inyectado vía DI).
- Configuración: base URL desde config/env, timeout, headers por defecto (Content-Type, Accept).
- **Interceptors**:
  - **Request**: añadir token de auth si existe (leer de SecureStore o store), idioma, correlation id si aplica.
  - **Response**: errores centralizados (401 → opcionalmente disparar logout o refresh; 4xx/5xx → normalizar a un tipo `AppError` o similar).
- No incluir lógica de negocio; solo transporte y transformación de errores a un formato común.
- Librería: `fetch` nativo, `axios` o `ky`; tipar respuestas con genéricos cuando sea posible.

Ejemplo de responsabilidades del cliente:

- `get<T>(path, config?)`, `post<T>`, `put<T>`, `patch<T>`, `delete<T>`.
- Recibir base URL desde config; no hardcodear dominios.
- Devolver datos tipados o lanzar / devolver error tipado (Result/Either o throw según convención del proyecto).

## Config y variables de entorno

- **Expo**: usar `expo-constants` (`Constants.expoConfig?.extra`) o `app.config.js` con `extra: { baseUrl: process.env.EXPO_PUBLIC_BASE_URL }`.
- Variables públicas: prefijo `EXPO_PUBLIC_` para exponer en el cliente.
- Centralizar en un módulo `src/core/config/app-config.ts`: exportar `baseUrl`, `apiTimeout`, flags, etc., leyendo de Constants o env.
- No esparcir `process.env` o `Constants.extra` por toda la app; un solo punto de lectura en core.

## Servicios compartidos

- **Storage**: wrapper sobre `expo-secure-store` (datos sensibles) y/o `@react-native-async-storage/async-storage` (preferencias, caché no sensible). Interfaz simple: `get`, `set`, `remove`, `clear` por clave.
- **Logging**: servicio que en dev escriba a consola y opcionalmente en producción envíe a un backend o lo suprima. No usar `console.log` directo en producción para datos sensibles.
- **Manejo de errores global**: si usas un error boundary o un handler global (ej. `ErrorUtils`), registrar o mostrar errores de forma consistente; el cliente API puede delegar ahí el log de 5xx o errores de red.
- **Analítica / eventos**: si aplica, un servicio en core que desacople el envío de eventos (firebase, segment, etc.) del resto de la app.

Todos estos servicios son **genéricos**: no conocen features concretos (auth, pedidos, etc.); los features los usan vía DI o imports de core.

## Dependencias entre capas

- **Core** no importa de `features/` ni de `app/` (rutas).
- Los **repositorios** (capa data de cada feature) importan y usan el **cliente API** de core; no crean su propia instancia de fetch/axios.
- Auth puede usar core para: SecureStore (almacenar token) y el cliente API (interceptor que añade el token). La lógica de “cuándo hacer login/logout” es del feature auth; el “cómo guardar” y “cómo enviar el token” es core.

## Buenas prácticas

1. Base URL y secrets desde env/config; nunca hardcodear en el cliente API.
2. Un solo punto de creación del cliente (factory o provider en raíz); reutilizar la misma instancia.
3. Errores de red/timeout: convertirlos a un tipo común (ej. `NetworkError`, `ServerError`) para que la UI o los repositorios traten sin depender de axios/fetch.
4. Interceptors ligeros: no poner lógica de negocio; solo headers, token y normalización de error.

## Cuándo usar este skill

- Crear o modificar el **cliente HTTP (ApiServices)**.
- Configurar **base URL**, timeout o interceptors.
- Añadir o cambiar **config** y variables de entorno.
- Implementar servicios compartidos en **core** (storage, logging, errores globales).
