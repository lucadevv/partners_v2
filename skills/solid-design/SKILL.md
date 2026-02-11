---
name: solid-design
description: >
  POO, SOLID y patrones de diseño en Partners. Cuándo y cómo aplicar abstracciones, contratos únicos e inyección.
  Trigger: Al crear servicios reutilizables, abstracciones compartidas, o al refactorizar para cumplir SOLID.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [root, core, features]
  auto_invoke:
    - "Applying SOLID or design patterns"
    - "Creating shared abstractions (e.g. permissions, strategies)"
    - "Refactoring to single responsibility or dependency inversion"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Objetivo

Aplicar **POO**, **SOLID** y **patrones de diseño** de forma consistente. Referencia detallada con ejemplos: [solid.md](../../solid.md) en la raíz del proyecto.

---

## SOLID en una frase cada uno

| Letra | Principio | En el proyecto |
|-------|-----------|----------------|
| **S** | Single Responsibility | Una clase, una razón para cambiar. Ej.: un UseCase = una acción; un servicio de permiso = un tipo (cámara, fotos, ubicación). |
| **O** | Open/Closed | Extender sin modificar. Nuevas implementaciones de `PermissionService` o estrategias sin tocar código existente. |
| **L** | Liskov Substitution | Cualquier impl del contrato puede sustituir a la abstracción sin romper el comportamiento esperado. |
| **I** | Interface Segregation | Interfaces pequeñas. Depender de `CameraPermissionService` si solo se necesita cámara; no de un “permiso genérico” con muchos métodos. |
| **D** | Dependency Inversion | Depender de abstracciones (abstract class / interface), no de implementaciones. Inyección vía GetIt. |

---

## Patrones usados en Partners

- **Repository**: Interfaz en domain, implementación en data. El dominio no conoce fuentes de datos concretas.
- **Use Case**: Una clase por acción de negocio; orquesta repositorios y validaciones.
- **Dependency Injection**: GetIt; las pantallas y Cubits reciben dependencias (Cubit, servicios) sin instanciarlas.
- **Strategy**: Varias formas de hacer algo (ej. validación RUC por tipo); se elige la estrategia por configuración o tipo.
- **Factory**: Creación centralizada (ej. `BranchConfigFactory`, `FlagsFactory`).
- **Contrato base único**: Una clase abstracta que todas las variantes implementan (ej. `PermissionService`), con implementaciones concretas por tipo.

---

## Ejemplo: servicios de permiso (contrato base + implementaciones)

Hay **una sola clase abstracta** que define el contrato; cada tipo de permiso tiene su implementación.

```
lib/core/services/permission/
├── permission_status.dart   # Enum del dominio (granted, denied, …)
├── permission_service.dart  # Abstract class PermissionService (request, isGranted, openAppSettings)
├── camera_permission_service.dart   # CameraPermissionService implements PermissionService
├── photos_permission_service.dart  # PhotosPermissionService implements PermissionService
├── location_permission_service.dart # LocationPermissionService implements PermissionService
└── permission.dart         # Barrel
```

- **PermissionService** (abstract): define `request()`, `isGranted()`, `openAppSettings()` y opcionalmente un helper estático (ej. `fromPh`) para no duplicar lógica.
- **CameraPermissionService** (abstract) **implements PermissionService**: contrato específico para cámara (permite inyectar “solo cámara” y cumple ISP).
- **CameraPermissionServiceImpl**: conoce `Permission.camera`, llama a `PermissionService.fromPh` y cumple el contrato.

La pantalla depende de **CameraPermissionService** o **PhotosPermissionService** (abstracciones), no de `permission_handler` ni de un método que reciba “qué permiso” por parámetro. Así se aplica **D** (Dependency Inversion) e **I** (Interface Segregation).

---

## Reglas prácticas

1. **Nuevos servicios reutilizables**: Definir una abstracción (abstract class o interface) en core; una o más implementaciones que la implementen. Registrar en GetIt por tipo (o por nombre si hay varias impl del mismo tipo).
2. **Evitar “God” servicios**: No un solo servicio que reciba un enum o parámetro para “qué permiso” o “qué estrategia”; preferir un contrato base y N implementaciones (una por tipo).
3. **No depender de detalles de plataforma en dominio/presentación**: El dominio y la UI dependen de abstracciones (PermissionService, Repository); la capa data o core conoce `permission_handler`, Dio, etc.
4. **Liskov**: Las implementaciones no deben lanzar excepciones o comportarse de forma distinta a lo que el tipo base promete (ej. no devolver `null` si el contrato dice `Future<PermissionStatus>`).

Para ejemplos largos (cafetería, pagos, bebidas), ver [solid.md](../../solid.md).
