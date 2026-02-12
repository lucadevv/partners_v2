# Repository Guidelines

## How to Use This Guide

- Start here for cross-project norms. Partners is a Flutter app with Clean Architecture and feature-first layout.
- This file is the single orchestrator; there are no nested AGENTS.md files inside features.
- Each **skill** in `skills/` provides detailed patterns for a domain. When your task matches an action in the **Auto-invoke Skills** table, invoke the corresponding skill FIRST (read `skills/<name>/SKILL.md`).
- Las **reglas de Cursor** en `.cursor/rules/` son obligatorias: aplicarlas cuando el contexto coincida (ver sección "Reglas de Cursor" más abajo).

## Reglas de Cursor (.cursor/rules)

Estas reglas detallan convenciones del proyecto. Los agentes deben aplicarlas según el tipo de tarea:

| Regla | Archivo | Cuándo aplicar |
|-------|---------|----------------|
| **Arquitectura** | `arquiecture.mdc` | Estructura feature-first, capas, BLoC/Cubit, RBAC, mappers, Either, SOLID, formularios con ChangeNotifier, **AutoRouteWrapper**, **RefreshIndicator** y botón Reintentar, colores con `withValues(alpha)`, barriles, Pencil→Flutter. |
| **Barrel files** | `barrel_files.mdc` | Crear o usar `domain.dart`, `data.dart`, `presentation.dart` por feature; barriles en `core/` por área (routes, utils, widgets, extension, models, theme). Imports desde barril cuando exista. |
| **Context extensions** | `context_extensions.mdc` | En UI: usar `context.appColor`, `context.appTextTheme`, `n.spaceh`, `n.spacew`. Import: `package:partners/core/extension/extension.dart`. Nunca `withOpacity`; usar `withValues(alpha: valor)`. |
| **Flutter UI / Pencil** | `flutter_ui_pencil.mdc` | ListView vs Column/Row, DecoratedBox vs Container, listas lazy (`ListView.builder`), opacidad, rendimiento (const, evitar widget `Opacity`). Traducir diseños .pen a Flutter. |

Antes de implementar UI, capas o barriles, revisar la regla correspondiente en `.cursor/rules/`.

## Available Skills

Use these skills for detailed patterns on-demand. If a skill file does not exist yet, follow this guide and the Code Style section.

### Generic Skills (Any Project)

| Skill | Description | URL |
|-------|-------------|-----|
| `flutter-3` | Clean Architecture, BLoC/Cubit, widget patterns | [SKILL.md](skills/flutter-3/SKILL.md) |
| `clean-architecture` | Domain/data/presentation separation | [SKILL.md](skills/clean-architecture/SKILL.md) |
| `solid-design` | POO, SOLID, patrones de diseño (Repository, Strategy, DI) | [SKILL.md](skills/solid-design/SKILL.md) |
| `state-management` | BLoC/Cubit, ChangeNotifier, providers | [SKILL.md](skills/state-management/SKILL.md) |
| `testing-flutter` | Unit, widget, integration tests | [SKILL.md](skills/testing-flutter/SKILL.md) |
| `auto-route` | Navigation, route generation, guards | [SKILL.md](skills/auto-route/SKILL.md) |
| `get-it-di` | Dependency injection, service location | [SKILL.md](skills/get-it-di/SKILL.md) |

### Partners-Specific Skills

| Skill | Description | URL |
|-------|-------------|-----|
| `partners` | Project overview, feature navigation | [SKILL.md](skills/partners/SKILL.md) |
| `partners-auth` | Authentication, document validation (DNI, CE, RUC), RBAC, secure storage | [SKILL.md](skills/partners-auth/SKILL.md) |
| `partners-branches` | Branch management, workers, schedules | [SKILL.md](skills/partners-branches/SKILL.md) |
| `partners-transactions` | Points system, transaction history | [SKILL.md](skills/partners-transactions/SKILL.md) |
| `partners-qr` | QR generation, scanning, ML Kit | [SKILL.md](skills/partners-qr/SKILL.md) |
| `partners-ui` | Widget patterns, theme, performance | [SKILL.md](skills/partners-ui/SKILL.md) |
| `partners-state` | BLoC/Cubit, Notifiers (ChangeNotifier), form state | [SKILL.md](skills/partners-state/SKILL.md) |
| `partners-layers` | How UI, state, domain, and data communicate | [SKILL.md](skills/partners-layers/SKILL.md) |
| `partners-domain` | Use cases, entities, repository interfaces | [SKILL.md](skills/partners-domain/SKILL.md) |
| `partners-data` | Data sources, mappers, models, repository impl | [SKILL.md](skills/partners-data/SKILL.md) |
| `partners-testing` | Testing overview and conventions (umbrella) | [SKILL.md](skills/partners-testing/SKILL.md) |
| `partners-testing-unit` | **Agente 1**: Unit tests (use cases, cubits, repos, mappers) | [SKILL.md](skills/partners-testing-unit/SKILL.md) |
| `partners-testing-widget` | **Agente 2**: Widget tests (screens, widgets) | [SKILL.md](skills/partners-testing-widget/SKILL.md) |
| `partners-testing-integration` | **Agente 3**: Integration tests (flujos E2E) | [SKILL.md](skills/partners-testing-integration/SKILL.md) |
| `partners-performance` | Container vs DecoratedBox, lazy loading | [SKILL.md](skills/partners-performance/SKILL.md) |
| `partners-rbac` | Role-based access control | [SKILL.md](skills/partners-rbac/SKILL.md) |

### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
|--------|-------|
| Adding new features with screens or business logic | `partners` |
| Creating or modifying authentication flows | `partners-auth` |
| Working with document validation (DNI, CE, RUC) | `partners-auth` |
| Implementing RBAC or permission checks | `partners-rbac` |
| Creating new transaction types or points logic | `partners-transactions` |
| Adding QR generation or scanning | `partners-qr` |
| Creating or modifying widgets, theme, screens, or UI components | `partners-ui` |
| Creating BLoC or Cubit classes | `partners-state` |
| Creating or modifying Notifiers (ChangeNotifier) or form state | `partners-state` |
| Understanding how UI, Cubit, UseCase, and Repository connect | `partners-layers` |
| Coordinating work across presentation, domain, or data layers | `partners-layers` |
| Optimizing performance, Container vs DecoratedBox, list rendering | `partners-performance` |
| Creating use cases or domain entities | `partners-domain` |
| Creating repository interfaces (domain layer) | `partners-domain` |
| Creating data sources, mappers, models, or repository implementations | `partners-data` |
| Writing tests (overview or mixed) | `partners-testing` |
| **Writing unit tests** (use cases, cubits, repos) | `partners-testing-unit` |
| **Writing widget tests** (screens, widgets) | `partners-testing-widget` |
| **Writing integration tests** (E2E flows) | `partners-testing-integration` |
| Working on branch management, workers, or schedules | `partners-branches` |
| Setting up or modifying AutoRoute routes or guards | `auto-route` |
| Setting up dependency injection (GetIt) | `get-it-di` |
| Writing Flutter tests (general patterns) | `testing-flutter` |
| Aplicar POO, SOLID o patrones de diseño (abstracciones, nuevos servicios) | `solid-design` |
| Crear o usar barrel files (domain/data/presentation, core) | Seguir `.cursor/rules/barrel_files.mdc` |

### Orden de los agentes de testing

Al añadir tests para un feature, seguir siempre este orden:

1. **Unit tests** (`partners-testing-unit`): Use cases, Cubits, repositorios, mappers. Sin UI.
2. **Widget tests** (`partners-testing-widget`): Pantallas y widgets con `pumpWidget` y mocks del Cubit.
3. **Integration tests** (`partners-testing-integration`): Flujos E2E en `integration_test/` con la app real.

Cada agente tiene su skill; invocar el que corresponda al tipo de test que se está escribiendo.

---

## Project Overview

Partners is a Flutter commerce app with a smart points system (Clean Architecture, feature-first).

| Layer | Location | Tech Stack |
|-------|----------|------------|
| Domain | `lib/features/*/domain/` | Use cases, entities, repository interfaces |
| Data | `lib/features/*/data/` | Data sources, models, mappers, repository impl |
| Presentation | `lib/features/*/presentation/` | Screens, widgets, BLoC/Cubit, notifiers |
| Core | `lib/core/` | Shared utilities, config, managers |
| Tests | `test/` | Unit, widget, integration |

Feature layout: `domain/` (entities, repository, use_case), `data/` (datasources, models, mappers, repositories), `presentation/` (cubit, screens, notifier, widgets).

### Un repositorio y un datasource por feature

- **Domain**: Un solo contrato de repositorio por feature (ej. `BranchesRepository`) con **todos** los métodos de ese dominio (getBranches, getCategories, …). No crear `CategoryRepository` aparte si las categorías son del feature branches; añadir `getCategories(page)` al repositorio del feature. Ver **partners-domain**.
- **Data**: Una sola interfaz de datasource por feature (ej. `BranchesDatasource`) con los mismos métodos que necesite la capa data. La implementación de red debe seguir el **mismo patrón try-catch que login**: `try { response; data = response.data; fromJson; return Right(model); } catch (e) { ExceptionHandler.handleException(e); ExceptionHandler.logException(..., tag: '...'); return Left(appException); }`. Un solo `catch (e)`, sin `on DioException` separado. Ver **partners-data**.

**Auth** (`lib/features/auth/`): Prefer a single layer (login + register in one feature). Use `auth/domain/`, `auth/data/`, `auth/presentation/`; orchestrator cubit in `auth/presentation/cubit/`. Do not add `auth/login/` or `auth/register/` with their own domain/data/presentation. Subfeatures (validation, document_scan, forgot_password, otp, registration_success) may keep their own layers. For DNI/CE/RUC, RBAC, tokens: use `partners-auth` skill.

---

## Flutter Development

```bash
# Setup
flutter pub get
dart run build_runner build

# Code quality
flutter analyze
dart format .
flutter test

# Build & run
flutter run
flutter build apk
flutter build ios
```

---

## POO, SOLID y patrones de diseño

El código debe aplicar **orientación a objetos**, **SOLID** y **patrones de diseño** de forma explícita. Referencia: [solid.md](solid.md).

| Principio | Aplicación en el proyecto |
|-----------|----------------------------|
| **S** (Single Responsibility) | Una clase, una responsabilidad. Ej.: un servicio de permiso por tipo (cámara, fotos, ubicación); cada UseCase hace una sola acción. |
| **O** (Open/Closed) | Extender sin modificar: nuevas implementaciones de una abstracción (ej. `PermissionService`, estrategias de pago) sin tocar el código existente. |
| **L** (Liskov Substitution) | Las implementaciones deben poder sustituir a la abstracción sin romper el contrato. No lanzar excepciones o comportarse de forma distinta a lo que el tipo base promete. |
| **I** (Interface Segregation) | Interfaces pequeñas y específicas. Depender de `CameraPermissionService` cuando solo se necesita cámara, no de un “permiso genérico” con muchos métodos. |
| **D** (Dependency Inversion) | Depender de abstracciones (interfaces/abstract class), no de implementaciones. Inyectar `PermissionService`/`Repository` vía GetIt; el cliente no conoce la impl concreta. |

**Patrones usados en el proyecto**: Repository (domain ↔ data), Use Case (lógica de negocio), Dependency Injection (GetIt), Factory (configuración/creación), Strategy (cuando hay varias formas de hacer algo). Al crear servicios reutilizables (ej. permisos), definir **una clase abstracta base** que todas las implementaciones utilicen (véase `PermissionService` en `lib/core/services/permission/`).

Para detalles y ejemplos (cafetería, pagos, bebidas), leer [solid.md](solid.md). Para aplicar esto al diseñar features o capas, usar el skill **solid-design**.

---

## Code Style (Flutter)

- **Performance**: Use `DecoratedBox` when only decoration is needed; `Container` when you need padding, margin, constraints, or alignment. Use `ListView.builder` for lists. Prefer `const` constructors.
- **State**: Use BLoC/Cubit for app and business logic; ChangeNotifier for complex forms (2+ campos o lógica compleja). Avoid `setState` for business logic.
- **Imports**: Use barrel exports when available (`package:partners/.../domain.dart`, `.../data.dart`, `.../presentation.dart`); ver `.cursor/rules/barrel_files.mdc`. Group: Flutter, third-party, project.
- **Theme y colores**: Preferir `context.appColor` y `context.appTextTheme` (ver `.cursor/rules/context_extensions.mdc`). Evitar colores hardcodeados.
- **Opacidad**: **Nunca** `withOpacity()` (deprecated). Usar `Color.withValues(alpha: valor)` con `valor` entre 0.0 y 1.0.
- **Pantallas con Cubit/Bloc y AutoRoute**: Implementar `AutoRouteWrapper` en la pantalla y poner el `BlocProvider` en `wrappedRoute`, no dentro de `build`.
- **Listas con datos remotos**: Envolver contenido desplazable en `RefreshIndicator` con `onRefresh` que llame al método de carga del Cubit. Botón "Reintentar"/"Retry" debe usar el mismo método de carga.
- **Naming**: Files snake_case, classes PascalCase, variables camelCase, constants UPPER_SNAKE_CASE.
- **Tamaño de pantallas**: Mantener cada `*_screen.dart` en **~200 líneas como máximo**; el resto extraer a widgets, modales, bottom sheets, helpers o listeners (ver skill **partners-ui**).

---

## Commit & Pull Request Guidelines

Follow conventional-commit style: `<type>[scope]: <description>`

**Types:** `feat`, `fix`, `docs`, `chore`, `perf`, `refactor`, `style`, `test`

**Scopes:** `auth`, `home`, `transactions`, `branches`, `qr`, `ui`, `core`

Before creating a PR:

1. Run `flutter analyze` and fix all issues.
2. Run `dart format .`.
3. Run `flutter test` and ensure all tests pass.
4. Add or update tests for the code you changed.
5. Test on both iOS and Android when possible.

---

## Troubleshooting

- **Build runner**: After changing models or routes, run `dart run build_runner build`.
- **Routes**: AutoRoute generates `app_routes.gr.dart`; do not edit by hand.
- **Theme**: Use `context.appColor` and extensions from `core/extension` when available.
- **Tests**: Use `flutter test --coverage` for coverage; import failures often come from barrel files or route imports.

### Permisos (permission_handler)

Para que **permission_handler** funcione correctamente:

- **Android**: En `android/app/src/main/AndroidManifest.xml` deben estar declarados los permisos que uses (CAMERA, READ_MEDIA_IMAGES, ACCESS_FINE_LOCATION, etc.). En `android/gradle.properties`: `android.useAndroidX=true` y `android.enableJetifier=true`. En `android/app/build.gradle.kts`: `compileSdk` ≥ 33 (recomendado 35).
- **iOS**: En `ios/Runner/Info.plist` deben existir las claves de uso (ej. `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSLocationWhenInUseUsageDescription`) con un texto para el usuario. En `ios/Podfile`, dentro de `post_install`, hay que definir los macros de permission_handler (`GCC_PREPROCESSOR_DEFINITIONS`) con `PERMISSION_CAMERA=1`, `PERMISSION_PHOTOS=1`, `PERMISSION_LOCATION_WHENINUSE=1` (y el resto en 0 si no se usan). Ver [documentación de permission_handler](https://pub.dev/packages/permission_handler).
