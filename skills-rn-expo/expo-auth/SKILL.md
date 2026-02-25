---
name: expo-auth
description: Autenticación en Expo: login, tokens, almacenamiento seguro y refresh.
license: Apache-2.0
metadata:
  scope: [react-native, expo, auth]
  auto_invoke: "Login, tokens, secure storage, refresh token"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-auth – Autenticación en Expo

## Alcance

- Flujo de login/logout y registro.
- Almacenamiento seguro de tokens (expo-secure-store).
- Refresh de access token y manejo de 401.
- Sincronización del estado de auth con la UI (Zustand/Context) y la navegación.

## Almacenamiento seguro

- Usar **expo-secure-store** para access token, refresh token y datos sensibles.
- No guardar tokens en AsyncStorage sin cifrado; usar SecureStore.
- Leer token al arranque para decidir ruta inicial (splash → login o home).

## Flujo de login

1. Pantalla de login envía credenciales al repositorio/servicio de auth.
2. API devuelve access + refresh (o solo access según backend).
3. Guardar en SecureStore y actualizar store (Zustand) o contexto.
4. Redirigir a la pantalla principal (Expo Router: `router.replace('/(tabs)')`).

## Refresh token

- Interceptor del cliente API: si la respuesta es 401, intentar refresh con el refresh token; si funciona, reenviar el request original; si falla, logout y redirigir a login.
- Evitar múltiples refreshes simultáneos (cola o flag).
- Al hacer logout, borrar tokens de SecureStore y limpiar estado global.

## Protección de rutas

- En el layout raíz o en el grupo de rutas protegidas: si no hay token (o token expirado y refresh falló), redirigir a `/(auth)/login`.
- Opcional: comprobar rol/permisos y redirigir o mostrar mensaje si no tiene acceso.

## Buenas prácticas

1. No dejar tokens en logs ni en estado en claro en dev más de lo necesario.
2. Expiración: si el backend devuelve exp, comprobar en cliente para no enviar tokens caducados; el refresh sigue siendo la fuente de verdad.
3. Persistir solo lo necesario: access + refresh; usuario (nombre, rol) puede ir en SecureStore o en memoria según sensibilidad.

## Cuándo usar este skill

- Implementar o modificar login/registro/logout.
- Guardar o leer tokens de forma segura.
- Configurar refresh y manejo de 401 en el cliente API.
