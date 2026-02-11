---
name: partners-layers
description: >
  How presentation, domain, and data layers communicate in Partners.
  Trigger: When coordinating work across layers, or when UI/state/domain/data must work together.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [root, presentation, domain, data]
  auto_invoke:
    - "Understanding how UI talks to BLoC/Notifier"
    - "Understanding how Cubit uses use cases"
    - "Coordinating work between presentation and domain or data"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Layer Communication (one-way)

Work is split by responsibility. Each subagent stays in its layer; communication is **one-way** so boundaries stay clear.

```
UI (screens/widgets)  →  State (Cubit / Notifier)  →  UseCase  →  Repository (interface)  →  RepositoryImpl (data)
     partners-ui              partners-state              partners-domain        partners-domain          partners-data
```

- **UI** (partners-ui): solo construye widgets y llama `context.read<Cubit>().method()`. No llama UseCase ni hace `fold`.
- **Cubit** (partners-state): llama UseCase, recibe `Either`, y **aquí se hace el fold** (emit failure o success). Referencia: auth/register. El UseCase puede tener validaciones de dominio y devolver `Left`; el Cubit interpreta ese Left con `fold` y emite el estado de error.
- **UseCase** (partners-domain): puede validar y devolver `Left(ValidationException(...))`; llama al repositorio y retorna `Either`. **Nunca** hace `fold` ni `emit`.
- **Data**: datasource y repository impl retornan `Either`; no hacen `fold`. El fold solo en Cubit.

## Reglas de capa (referencia: .cursor/rules/arquiecture.mdc)

- **Data** no debe importar nada de **Presentation**.
- **Domain** no debe importar nada de **Data** ni Flutter/material.
- **Presentation** (Cubit/Bloc) solo se comunica con Domain vía **Use Cases**; no llama repositorios ni datasources directamente.
- **Mapeo**: siempre usar **Mappers** para convertir entre Models (Data) y Entities (Domain). No exponer modelos de red/DB fuera de la capa data.

## File Conventions

```
lib/features/<feature>/
├── domain/
│   ├── entities/           # Pure business objects
│   ├── repository/         # Abstract interfaces only
│   └── use_case/           # One class per use case
├── data/
│   ├── datasources/        # API, local DB
│   ├── models/             # DTOs
│   ├── mappers/            # Model ↔ Entity
│   └── repositories/       # Implements domain repository
└── presentation/
    ├── cubit/              # BLoC/Cubit (app/feature state)
    ├── notifier/           # ChangeNotifier (complex forms)
    ├── screens/            # Full screens
    └── widgets/            # Reusable UI
```

## Who Does What (subagents) — referencia: auth/register

| Responsabilidad | Skill | Regla |
|------------------|--------|--------|
| Screens, widgets, theme | `partners-ui` | Solo lee estado y llama al Cubit. No UseCase, no `fold`. |
| Cubit (y Notifier para formularios) | `partners-state` | **Solo aquí se hace `fold`** del Either del UseCase. Llama UseCase, luego `response.fold(emit failure, emit success)`. |
| Use cases, entidades, repo (interfaz) | `partners-domain` | UseCase puede validar y devolver `Left`; llama repo y retorna Either. Nunca `fold` ni `emit`. |
| Datasource, models, mappers, repo impl | `partners-data` | Retornan Either; convierten con mapper. No `fold`. |

## Example: UI → State → UseCase → Repository

```dart
// 1) UI (partners-ui): only reads Cubit and dispatches events
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) { /* navigate on success */ },
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () => context.read<LoginCubit>().login(email, password),
            child: Text('Login'),
          );
        },
      ),
    );
  }
}

// 2) State (partners-state): Cubit calls UseCase only
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  LoginCubit(this._loginUseCase) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    final result = await _loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (l) => emit(LoginError(l.message)),
      (r) => emit(LoginSuccess(r)),
    );
  }
}

// 3) Domain (partners-domain): UseCase calls repository interface
class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);
  Future<Either<Failure, LoginResponse>> call(LoginParams p) => _repo.login(p);
}

// 4) Data (partners-data): Implements AuthRepository, uses DataSource and Mapper
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final AuthMapper _mapper;
  // ...
}
```

## When to Use This Skill

- Before adding a new flow: decide which layer each new file belongs to.
- When UI needs “something from backend”: UI → Cubit → UseCase → Repository; never UI → UseCase directly in the widget.
- When multiple people/agents work on the same feature: each stays in one layer and uses this contract.
