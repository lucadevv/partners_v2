# Skills

This folder contains **skills**: detailed, on-demand instructions for AI coding agents. Each subfolder has a `SKILL.md` file. The root [AGENTS.md](../AGENTS.md) defines when to invoke each skill (see **Auto-invoke Skills** table there).

Las **reglas de Cursor** en [.cursor/rules/](../.cursor/rules/) son obligatorias y complementan los skills: arquitectura (`arquiecture.mdc`), barrel files (`barrel_files.mdc`), extensiones de contexto (`context_extensions.mdc`), UI/Pencil→Flutter (`flutter_ui_pencil.mdc`). Varios skills referencian estas reglas; ver también la sección "Reglas de Cursor" en AGENTS.md.

## Generic Skills (Any Project)

| Skill | Description |
|-------|-------------|
| [flutter-3](flutter-3/SKILL.md) | Clean Architecture, BLoC/Cubit, widget patterns |
| [clean-architecture](clean-architecture/SKILL.md) | Domain/data/presentation separation |
| [state-management](state-management/SKILL.md) | BLoC/Cubit, ChangeNotifier |
| [testing-flutter](testing-flutter/SKILL.md) | Unit, widget, integration tests |
| [auto-route](auto-route/SKILL.md) | Navigation, routes, guards |
| [get-it-di](get-it-di/SKILL.md) | Dependency injection |

## Partners-Specific Skills

| Skill | Description |
|-------|-------------|
| [partners](partners/SKILL.md) | Project overview, feature navigation |
| [partners-auth](partners-auth/SKILL.md) | Auth, document validation (DNI, CE, RUC), RBAC |
| [partners-branches](partners-branches/SKILL.md) | Branches, workers, schedules |
| [partners-transactions](partners-transactions/SKILL.md) | Points, transactions |
| [partners-qr](partners-qr/SKILL.md) | QR, scanning, ML Kit |
| [partners-ui](partners-ui/SKILL.md) | Widgets, theme, performance |
| [partners-state](partners-state/SKILL.md) | BLoC/Cubit, Notifiers, form state |
| [partners-layers](partners-layers/SKILL.md) | How UI, state, domain, data communicate |
| [partners-domain](partners-domain/SKILL.md) | Use cases, entities, repositories |
| [partners-data](partners-data/SKILL.md) | Data sources, mappers, models |
| [partners-testing](partners-testing/SKILL.md) | Test conventions |
| [partners-performance](partners-performance/SKILL.md) | Container vs DecoratedBox, lazy loading |
| [partners-rbac](partners-rbac/SKILL.md) | Role-based access control |

For the full **Auto-invoke** table (which skill to read first for each action), see [AGENTS.md](../AGENTS.md).
