---
name: partners-domain
description: >
  Domain layer patterns for Partners app - use cases, entities, repositories.
  Trigger: Creating use cases, entities, repositories, domain business logic.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [domain]
  auto_invoke:
    - "Creating use cases or entities"
    - "Creating/modifying repositories (interfaces)"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## File Conventions

```
lib/features/<feature>/domain/
├── domain.dart              # Barrel: exporta entidades, repo interfaces, use cases (ver .cursor/rules/barrel_files.mdc)
├── entities/                # Pure business objects, no Flutter
│   └── entity_name.dart
├── repository/              # Abstract interfaces only
│   └── feature_repository.dart
└── use_case/                # One class per use case
    └── do_something_usecase.dart
```

- No imports from `data/` or `presentation/`. No Flutter, no Dio. Reglas de capa: `.cursor/rules/arquiecture.mdc`.
- Entities: equality (Equatable), immutable where possible.
- Repository: only method signatures; implementation lives in `data/repositories/`. Para SOLID y cuándo introducir abstracciones, ver skill **solid-design**.

## Reglas clave (referencia: auth/register)

- **UseCase**:
  - **Puede** tener validaciones de dominio: si no se cumple la regla, `return Left(ValidationException('mensaje'))` (ej. RUC inválido, documento inválido, sesión vacía). Ver `SendRucUsecase`, `SendDocumentUsecase`.
  - Luego llama al repositorio y retorna `return await _repository.method(...)`.
  - **Nunca** hace `fold` ni `emit`. El **fold** del resultado solo se hace en el **Cubit** (capa presentation).
- **Repository (interfaz)**: métodos que devuelven `Future<Either<AppException, Entity>>`. La implementación está en data.

## UseCase: validaciones sí, fold no (ejemplo register)

```dart
// SendRucUsecase: validación de dominio en el use case; retorna Left o llama repo
Future<Either<AppException, RegisterResponseEntity>> call({
  required RucType type,
  required String ruc,
}) async {
  final strategy = RucConfigFactory.getValidatorStrategy(type);
  if (!strategy.validate(ruc)) {
    return Left(ValidationException('Ruc no valido'));
  }
  final entity = EntityRq(ruc: ruc);
  return await _repository.validateComerce(entity: entity);
}
```

El Cubit es quien hace `response.fold((failure) => emit(...), (success) => emit(...))`.

## Domain Layer Overview

The domain layer contains pure business logic without any external dependencies.

## Core Components

### Entities
Pure business objects that represent core concepts.

### Repositories (Interfaces)
Contracts for data access; return `Either<AppException, T>`. Implemented by the data layer.

### Use Cases
May validate domain rules (return `Left` if invalid); call repository and return its `Either`. Do **not** use `fold` or emit—only the Cubit does that.

## Entity Patterns

### Base Entity
```dart
abstract class BaseEntity {
  String get id;
  DateTime get createdAt;
  DateTime? get updatedAt;
}

class Entity extends BaseEntity {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  const Entity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity && runtimeType == other.runtimeType && id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}
```

### User Entity
```dart
class User extends Entity {
  final String email;
  final String name;
  final UserRole role;
  final String? documentType;
  final String? documentNumber;
  final bool isActive;
  
  const User({
    required String id,
    required this.email,
    required this.name,
    required this.role,
    this.documentType,
    this.documentNumber,
    this.isActive = true,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  User copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? documentType,
    String? documentNumber,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

### Transaction Entity
```dart
class Transaction extends Entity {
  final String customerId;
  final String customerName;
  final int points;
  final String description;
  final TransactionType type;
  final TransactionStatus status;
  final String? branchId;
  
  const Transaction({
    required String id,
    required this.customerId,
    required this.customerName,
    required this.points,
    required this.description,
    required this.type,
    required this.status,
    this.branchId,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  // Business logic
  bool get isDebit => type == TransactionType.debit;
  bool get isCredit => type == TransactionType.credit;
  bool get isCompleted => status == TransactionStatus.completed;
  
  String get formattedPoints => '${isDebit ? '-' : '+'}$points puntos';
  String get typeDisplay => type == TransactionType.debit ? 'Emisión' : 'Canje';
}
```

## Repository Patterns

### Base Repository Interface
```dart
abstract class BaseRepository<T extends Entity> {
  Future<Either<Failure, T>> getById(String id);
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, void>> save(T entity);
  Future<Either<Failure, void>> delete(String id);
  Future<Either<Failure, List<T>>> findWhere(bool Function(T) predicate);
}
```

### Feature-Specific Repository
```dart
abstract class AuthRepository {
  Future<Either<AuthFailure, User>> login({
    required String documentType,
    required String documentNumber,
    required String password,
  });
  
  Future<Either<AuthFailure, User>> register({
    required String email,
    required String name,
    required String password,
    required String documentType,
    required String documentNumber,
  });
  
  Future<Either<AuthFailure, void>> logout();
  Future<Either<AuthFailure, User?>> getCurrentUser();
  Future<Either<AuthFailure, bool>> isLoggedIn();
}
```

### Transaction Repository
```dart
abstract class TransactionRepository {
  Future<Either<TransactionFailure, List<Transaction>>> getTransactions({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  });
  
  Future<Either<TransactionFailure, Transaction>> createTransaction({
    required String customerId,
    required String customerName,
    required int points,
    required String description,
    required TransactionType type,
    String? branchId,
  });
  
  Future<Either<TransactionFailure, void>> updateTransactionStatus({
    required String transactionId,
    required TransactionStatus status,
  });
  
  Future<Either<TransactionFailure, List<Transaction>>> getRecentTransactions({
    int limit = 10,
  });
}
```

## Use Case Patterns

### Base Use Case
```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}
```

### Authentication Use Cases
```dart
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _authRepository;
  
  LoginUseCase(this._authRepository);
  
  @override
  Future<Either<AuthFailure, User>> call(LoginParams params) async {
    // Validate input
    if (params.documentType.isEmpty || params.documentNumber.isEmpty) {
      return Left(AuthFailure.invalidCredentials);
    }
    
    if (params.password.length < 8) {
      return Left(AuthFailure.invalidPassword);
    }
    
    // Call repository
    final result = await _authRepository.login(
      documentType: params.documentType,
      documentNumber: params.documentNumber,
      password: params.password,
    );
    
    return result;
  }
}

class LoginParams {
  final String documentType;
  final String documentNumber;
  final String password;
  
  const LoginParams({
    required this.documentType,
    required this.documentNumber,
    required this.password,
  });
}
```

### Transaction Use Cases
```dart
class IssuePointsUseCase implements UseCase<Transaction, IssuePointsParams> {
  final TransactionRepository _transactionRepository;
  
  IssuePointsUseCase(this._transactionRepository);
  
  @override
  Future<Either<TransactionFailure, Transaction>> call(IssuePointsParams params) async {
    // Business validation
    if (params.points <= 0) {
      return Left(TransactionFailure.invalidAmount);
    }
    
    if (params.customerName.trim().isEmpty) {
      return Left(TransactionFailure.invalidCustomer);
    }
    
    if (params.branchId == null) {
      return Left(TransactionFailure.branchRequired);
    }
    
    // Create transaction
    final transaction = await _transactionRepository.createTransaction(
      customerId: params.customerId,
      customerName: params.customerName,
      points: params.points,
      description: params.description ?? 'Emisión de puntos',
      type: TransactionType.debit,
      branchId: params.branchId,
    );
    
    return transaction;
  }
}

class IssuePointsParams {
  final String customerId;
  final String customerName;
  final int points;
  final String? description;
  final String? branchId;
  
  const IssuePointsParams({
    required this.customerId,
    required this.customerName,
    required this.points,
    this.description,
    this.branchId,
  });
}
```

### Get Use Cases
```dart
class GetRecentTransactionsUseCase implements UseCase<List<Transaction>, NoParams> {
  final TransactionRepository _transactionRepository;
  
  GetRecentTransactionsUseCase(this._transactionRepository);
  
  @override
  Future<Either<TransactionFailure, List<Transaction>>> call(NoParams params) async {
    return await _transactionRepository.getRecentTransactions(limit: 10);
  }
}

class GetTransactionsByBranchUseCase implements UseCase<List<Transaction>, GetTransactionsParams> {
  final TransactionRepository _transactionRepository;
  
  GetTransactionsByBranchUseCase(this._transactionRepository);
  
  @override
  Future<Either<TransactionFailure, List<Transaction>>> call(GetTransactionsParams params) async {
    return await _transactionRepository.getTransactions(
      branchId: params.branchId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
```

## Error Handling Patterns

### Failure Base Class
```dart
abstract class Failure {
  final String message;
  
  const Failure(this.message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure && runtimeType == other.runtimeType && message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  String toString() => 'Failure: $message';
}
```

### Specific Failures
```dart
class AuthFailure extends Failure {
  const AuthFailure._(String message) : super(message);
  
  static const AuthFailure invalidCredentials = AuthFailure._('Invalid credentials');
  static const AuthFailure invalidPassword = AuthFailure._('Password too short');
  static const AuthFailure userNotFound = AuthFailure._('User not found');
  static const AuthFailure tokenExpired = AuthFailure._('Token expired');
  static const AuthFailure networkError = AuthFailure._('Network error');
  
  factory AuthFailure.custom(String message) => AuthFailure._(message);
}

class TransactionFailure extends Failure {
  const TransactionFailure._(String message) : super(message);
  
  static const TransactionFailure invalidAmount = TransactionFailure._('Invalid amount');
  static const TransactionFailure invalidCustomer = TransactionFailure._('Invalid customer');
  static const TransactionFailure branchRequired = TransactionFailure._('Branch required');
  static const TransactionFailure insufficientPoints = TransactionFailure._('Insufficient points');
  
  factory TransactionFailure.custom(String message) => TransactionFailure._(message);
}
```

## Either Pattern Implementation

```dart
class Either<L, R> {
  final L? _left;
  final R? _right;
  
  Either.left(L left) : _left = left, _right = null;
  Either.right(R right) : _left = null, _right = right;
  
  bool get isLeft => _left != null;
  bool get isRight => _right != null;
  
  L? get left => _left;
  R? get right => _right;
  
  T fold<T>(T Function(L) ifLeft, T Function(R) ifRight) {
    if (isLeft) {
      return ifLeft(_left as L);
    } else {
      return ifRight(_right as R);
    }
  }
  
  Either<L, R2> map<R2>(R2 Function(R) fn) {
    if (isRight) {
      return Either.right(fn(_right as R));
    } else {
      return Either.left(_left as L);
    }
  }
}
```

## Business Rules and Validations

### Value Objects
```dart
class Email {
  final String value;
  
  Email._(this.value);
  
  static Either<EmailValidationFailure, Email> create(String input) {
    if (input.trim().isEmpty) {
      return Left(EmailValidationFailure.empty);
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(input)) {
      return Left(EmailValidationFailure.invalid);
    }
    
    return Right(Email._(input.trim().toLowerCase()));
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Email && value == other.value;
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => value;
}

enum EmailValidationFailure {
  empty,
  invalid,
}

class DocumentNumber {
  final String value;
  final DocumentType type;
  
  DocumentNumber._(this.value, this.type);
  
  static Either<DocumentValidationFailure, DocumentNumber> create({
    required String input,
    required DocumentType type,
  }) {
    if (input.trim().isEmpty) {
      return Left(DocumentValidationFailure.empty);
    }
    
    final pattern = _getPattern(type);
    if (!RegExp(pattern).hasMatch(input)) {
      return Left(DocumentValidationFailure.invalidFormat);
    }
    
    return Right(DocumentNumber._(input.trim(), type));
  }
  
  static String _getPattern(DocumentType type) {
    switch (type) {
      case DocumentType.dni:
        return r'^\d{8}$';
      case DocumentType.ce:
        return r'^\d{8}[A-Z]$';
      case DocumentType.ruc:
        return r'^\d{11}$';
    }
  }
}
```

## Testing Domain Layer

### Use Case Testing
```dart
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group('IssuePointsUseCase', () {
    late IssuePointsUseCase useCase;
    late MockTransactionRepository mockRepository;
    
    setUp(() {
      mockRepository = MockTransactionRepository();
      useCase = IssuePointsUseCase(mockRepository);
    });
    
    test('should issue points successfully with valid parameters', () async {
      // Arrange
      final params = IssuePointsParams(
        customerId: 'customer1',
        customerName: 'John Doe',
        points: 100,
        description: 'Test transaction',
        branchId: 'branch1',
      );
      
      final expectedTransaction = Transaction(
        id: 'transaction1',
        customerId: params.customerId,
        customerName: params.customerName,
        points: params.points,
        description: params.description!,
        type: TransactionType.debit,
        status: TransactionStatus.completed,
        branchId: params.branchId,
        createdAt: DateTime.now(),
      );
      
      when(() => mockRepository.createTransaction(any()))
          .thenAnswer((_) async => Right(expectedTransaction));
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isRight, true);
      expect(result.right, equals(expectedTransaction));
      verify(() => mockRepository.createTransaction(any())).called(1);
    });
    
    test('should return failure when points are zero or negative', () async {
      // Arrange
      final params = IssuePointsParams(
        customerId: 'customer1',
        customerName: 'John Doe',
        points: 0,
        description: 'Test transaction',
        branchId: 'branch1',
      );
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isLeft, true);
      expect(result.left, equals(TransactionFailure.invalidAmount));
      verifyNever(() => mockRepository.createTransaction(any()));
    });
  });
}
```

## File Organization

```
lib/features/feature_name/domain/
├── entities/
│   ├── user_entity.dart
│   ├── transaction_entity.dart
│   └── branch_entity.dart
├── repositories/
│   ├── auth_repository.dart
│   ├── transaction_repository.dart
│   └── branch_repository.dart
├── use_cases/
│   ├── auth/
│   │   ├── login_usecase.dart
│   │   ├── register_usecase.dart
│   │   └── logout_usecase.dart
│   ├── transactions/
│   │   ├── issue_points_usecase.dart
│   │   ├── get_transactions_usecase.dart
│   │   └── get_recent_transactions_usecase.dart
│   └── branches/
│       ├── create_branch_usecase.dart
│       └── get_branches_usecase.dart
├── failures/
│   ├── auth_failure.dart
│   └── transaction_failure.dart
├── value_objects/
│   ├── email.dart
│   ├── document_number.dart
│   └── points.dart
└── domain.dart // barrel export
```

## Related Skills

- `partners` - Project overview and navigation
- `partners-data` - Data layer implementation
- `partners-testing` - Testing patterns
- `clean-architecture` - Clean Architecture principles
- `dart-patterns` - Dart language patterns