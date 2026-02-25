---
name: expo-data
description: Capa de datos en Expo: repositorios, uso del cliente API (core), React Query/SWR y mappers. Genérico para cualquier feature.
license: Apache-2.0
metadata:
  scope: [react-native, expo, data]
  auto_invoke: "Repositorios, React Query, mappers, hooks de datos"
allowed-tools: Read, Edit, Write, Glob, Grep
---

# expo-data – Capa de datos en Expo

## Alcance

- **Repositorios** que implementan contratos del domain y usan el **cliente HTTP de core** (ver **expo-core**).
- React Query (TanStack Query) o SWR para caché y estado de servidor.
- Mappers DTO → entidad de dominio.
- Patrones genéricos para cualquier feature (listas, detalles, mutaciones).

El **cliente HTTP (ApiServices)** no se define aquí: vive en **core** y se configura según **expo-core**. La capa data solo lo consume.

## Cliente API (referencia)

- El cliente HTTP es responsabilidad de **expo-core**: base URL, interceptors, auth, manejo de errores. Ver [expo-core](../expo-core/SKILL.md).
- Los repositorios reciben el cliente inyectado o lo importan de core y lo usan para hacer `get`, `post`, etc.
- No crear instancias de fetch/axios dentro de repositorios; usar siempre el cliente centralizado de core.

## Repositorios

- Implementan la interfaz definida en `domain/repositories`.
- Dentro del repositorio: llamar al cliente API, mapear respuesta a entidades o DTOs, devolver tipos de domain.
- No exponer DTOs ni detalles de red a la capa de presentación; solo entidades y posibles errores tipados.

Ejemplo de flujo:

```
Presentation (hook) → Repository (interface) → RepositoryImpl → API client → mapper → entity
```

## React Query / SWR

- Para listas, detalles y mutaciones: usar `useQuery`, `useMutation`, `useInfiniteQuery` según el caso.
- El hook puede vivir en `presentation/hooks/` y usar el repositorio inyectado o un servicio de API dedicado.
- Keys de query consistentes para invalidación (ej. `['users'], ['user', id]`).
- Configurar `staleTime`, `retry` y manejo de errores en el cliente de Query.

## Mappers

- Funciones puras: `dtoToEntity(dto): Entity`; opcionalmente `entityToDto` si se envían datos al servidor.
- Ubicación: `data/mappers/` del feature.
- No incluir lógica de negocio; solo transformación de estructura.

## Buenas prácticas

1. No llamar fetch/axios desde componentes; siempre a través de repositorio o hook que use el repositorio.
2. Errores: convertir a un tipo de error de dominio o a un mensaje conocido; no dejar excepciones crudas en la UI.
3. Tipado estricto en respuestas: validar con Zod o similar si la API no es de confianza.

## Cuándo usar este skill

- Crear o modificar **repositorios** que consumen el API.
- Definir **mappers** DTO → entidad.
- Configurar **React Query/SWR** o estrategias de caché.

Para crear o modificar el **cliente HTTP (ApiServices)**, config o servicios de **core**, usar **expo-core**.
