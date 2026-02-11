---
name: partners
description: >
  Main entry point for Partners development - quick reference for all components.
  Trigger: General Partners development questions, project overview, component navigation (NOT specific features).
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [root]
  auto_invoke: "General Partners development questions"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Project Overview

Partners is a Flutter commerce app with smart points system, following Clean Architecture + Feature-First approach.

## Components

| Component | Stack | Location |
|-----------|-------|----------|
| Domain | Pure Dart, Use Cases, Entities | `lib/features/*/domain/` |
| Data | Models, Data Sources, Repositories | `lib/features/*/data/` |
| Presentation | Screens, Widgets, BLoC/Cubit | `lib/features/*/presentation/` |
| Core | Shared utilities, managers | `lib/core/` |

## Features

| Feature | Description |
|--------|-------------|
| auth | Authentication, document validation (DNI, CE, RUC) |
| home | Dashboard, smart cards, tools |
| branches | Branch management, workers, schedules |
| transactions | Points system, transaction history |
| qr | QR generation, scanning, ML Kit |
| issue_points | Point issuance interface |
| users | User management, RBAC |

## Quick Commands

```bash
# Setup
flutter pub get
flutter pub run build_runner build

# Development
flutter run
flutter analyze
dart format .

# Testing
flutter test
flutter test --coverage
flutter test integration_test/

# Build
flutter build apk
flutter build ios
```

## Key Technologies

- **Flutter 3.10.1+** with Clean Architecture
- **BLoC/Cubit** for state management
- **Auto Route** for navigation
- **Dio** for networking
- **GetIt** for dependency injection
- **Mapbox** for maps
- **ML Kit** for text recognition
- **SQLite** for local storage

## Reglas de Cursor (.cursor/rules)

El proyecto tiene reglas detalladas en `.cursor/rules/`. Aplicar según la tarea:

| Regla | Contenido principal |
|-------|----------------------|
| **arquiecture.mdc** | Feature-first, capas, BLoC/Cubit, RBAC, mappers, Either, SOLID, ChangeNotifier para formularios, AutoRouteWrapper, RefreshIndicator/Reintentar, `withValues(alpha)`, barriles, Pencil→Flutter. |
| **barrel_files.mdc** | Barriles por capa (`domain.dart`, `data.dart`, `presentation.dart`) en cada feature; en core por área. Imports desde barril. |
| **context_extensions.mdc** | `context.appColor`, `context.appTextTheme`, `n.spaceh`, `n.spacew`. Nunca `withOpacity`. |
| **flutter_ui_pencil.mdc** | ListView vs Column/Row, DecoratedBox vs Container, listas lazy, opacidad, rendimiento. |

Cuando trabajes en UI, capas, estado o barriles, consultar la regla correspondiente.

## Architecture Rules

### Clean Architecture Layers
- **Domain**: Pure business logic, no Flutter dependencies
- **Data**: Data sources, models, mappers, repository implementations
- **Presentation**: UI components, state management (BLoC/Cubit)

### Feature Structure
```
lib/features/feature_name/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── use_cases/
├── data/
│   ├── datasources/
│   ├── models/
│   ├── mappers/
│   └── repositories/
└── presentation/
    ├── cubit/
    ├── screens/
    └── widgets/
```

## Performance Rules

- ✅ Use `DecoratedBox` when only decoration is needed
- ✅ Use `Container` when you need padding, margin, constraints, alignment, OR decoration
- ✅ Use `ListView.builder` for lists (lazy loading)
- ✅ Use `const` constructors for widgets that don't change

## State Management Rules

- ✅ Use `ChangeNotifier` for complex forms (multiple controllers, validation)
- ✅ Use `BLoC/Cubit` for app state and business logic
- ✅ Avoid `setState` in complex widgets

## Related Skills

- `partners-auth` - Authentication, document validation, RBAC
- `partners-branches` - Branch management, workers, schedules
- `partners-transactions` - Points system, transaction history
- `partners-qr` - QR generation, scanning, ML Kit
- `partners-ui` - Widget patterns, theme, performance
- `partners-domain` - Use cases, entities, repositories
- `partners-data` - Data sources, mappers, models
- `partners-testing` - Unit tests, widget tests, integration tests
- `partners-performance` - Container vs DecoratedBox, lazy loading
- `partners-rbac` - Role-based access control

## Code Style Guidelines

### Import Rules
- ✅ Use barrel exports: `import 'package:partners/core/routes/routes.dart'`
- ✅ Avoid direct imports when barrel export exists
- ✅ Group imports: flutter, third-party, project

### Theme and Colors
- ✅ Prefer `context.appColor` and `context.appTextTheme` (see `.cursor/rules/context_extensions.mdc`)
- ✅ Never use `withOpacity()`; use `Color.withValues(alpha: 0.0–1.0)`

### Naming Conventions
- ✅ Features: snake_case (`home_screen.dart`, `auth_cubit.dart`)
- ✅ Files: snake_case
- ✅ Classes: PascalCase
- ✅ Variables: camelCase
- ✅ Constants: UPPER_SNAKE_CASE

## Resources

- **Dependencies**: See `pubspec.yaml` for full package list
- **Testing**: Use `bloc_test` for BLoC/Cubit, `mocktail` for mocking
- **Performance**: Profile with Flutter DevTools
- **Documentation**: Use DartDoc for public APIs