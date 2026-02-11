---
name: partners-data
description: >
  Data layer patterns for Partners app - data sources, models, mappers, repository implementations.
  Trigger: Creating data sources, models, mappers, repository implementations.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [data]
  auto_invoke:
    - "Creating repositories or data sources"
    - "Creating data models or mappers"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## File Conventions

```
lib/features/<feature>/data/
├── data.dart                # Barrel: exporta models, datasources, mappers, repo impl (ver .cursor/rules/barrel_files.mdc)
├── datasources/             # Remote, local; interfaces + impl
│   ├── feature_datasource.dart
│   └── feature_remote_datasource_impl.dart
├── models/                  # DTOs, JSON serialization
│   └── feature_model.dart
├── mappers/                 # Model ↔ Entity (obligatorio; no exponer models fuera de data)
│   └── feature_mapper.dart
└── repositories/            # Implements domain repository interface
    └── feature_repository_impl.dart
```

- Depends on `domain/` (entities, repository interface). **No** dependency on `presentation/` (`.cursor/rules/arquiecture.mdc`).
- Models: fromJson/toJson; **siempre** usar Mappers para convertir Model ↔ Entity; no exponer modelos de red/DB fuera de la capa data.

## Reglas clave (referencia: auth/register)

- **Datasource** (interfaz e impl): retorna `Future<Either<AppException, Model>>`. La impl hace la llamada (API, etc.) y devuelve `Right(model)` o `Left(AppException)`. No hace `fold`; solo retorna Either.
- **Repository impl**: llama al datasource, convierte con mapper (ej. `response.map((model) => Mapper.modelToEntity(model))`) y retorna `Either<AppException, Entity>`. Tampoco hace `fold`; el **fold** es solo en el **Cubit**.

Ejemplo (auth/register):

```dart
// RegisterRepositoryImpl: llama datasource, .map con mapper, retorna Either
@override
Future<Either<AppException, StartRegisterResEntity>> startRegister({
  required StartRegisterReq entity,
}) async {
  final response = await _datasource.startRegister(entity: entity);
  return response.map((model) => StartRegisterMapper.modelToEntity(model));
}
```

## Data Layer Overview

The data layer implements domain contracts and handles external data sources.

## Core Components

### Data Sources
External data access (API, local database, secure storage).

### Models
Data transfer objects that map to/from external formats.

### Mappers
Convert between domain entities and data models.

### Repository Implementations
Concrete implementations of domain repository interfaces.

## Data Source Patterns

### Base Data Source Interface
```dart
abstract class BaseDataSource<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<T> create(T item);
  Future<T> update(T item);
  Future<void> delete(String id);
}
```

### Remote Data Source (API)
```dart
abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String documentType,
    required String documentNumber,
    required String password,
  });
  
  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String password,
    required String documentType,
    required String documentNumber,
  });
  
  Future<void> logout();
  Future<Map<String, dynamic>?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;
  
  AuthRemoteDataSourceImpl({
    required Dio dio,
    required String baseUrl,
  }) : _dio = dio, _baseUrl = baseUrl;
  
  @override
  Future<Map<String, dynamic>> login({
    required String documentType,
    required String documentNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {
          'document_type': documentType,
          'document_number': documentNumber,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException(message: 'Login failed');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
```

### Local Data Source (SQLite)
```dart
abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
  });
  
  Future<TransactionModel> saveTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10});
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Database _database;
  
  TransactionLocalDataSourceImpl(this._database);
  
  @override
  Future<List<TransactionModel>> getTransactions({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final maps = await _database.query(
      'transactions',
      where: _buildWhereClause(branchId, startDate, endDate),
      orderBy: 'created_at DESC',
    );
    
    return maps.map((map) => TransactionModel.fromJson(map)).toList();
  }
  
  String _buildWhereClause(String? branchId, DateTime? startDate, DateTime? endDate) {
    final conditions = <String>[];
    
    if (branchId != null) {
      conditions.add('branch_id = "$branchId"');
    }
    
    if (startDate != null) {
      conditions.add('created_at >= ${startDate.millisecondsSinceEpoch}');
    }
    
    if (endDate != null) {
      conditions.add('created_at <= ${endDate.millisecondsSinceEpoch}');
    }
    
    return conditions.isNotEmpty ? conditions.join(' AND ') : '1=1';
  }
  
  @override
  Future<TransactionModel> saveTransaction(TransactionModel transaction) async {
    final id = await _database.insert(
      'transactions',
      transaction.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    return transaction.copyWith(id: id.toString());
  }
}
```

### Secure Storage Data Source
```dart
abstract class AuthSecureDataSource {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
  Future<DateTime?> getTokenExpiration();
  Future<void> saveTokenExpiration(DateTime expiration);
}

class AuthSecureDataSourceImpl implements AuthSecureDataSource {
  final FlutterSecureStorage _secureStorage;
  
  static const String _tokenKey = 'auth_token';
  static const String _expirationKey = 'token_expiration';
  
  AuthSecureDataSourceImpl(this._secureStorage);
  
  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }
  
  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }
  
  @override
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _expirationKey);
  }
  
  @override
  Future<DateTime?> getTokenExpiration() async {
    final expirationString = await _secureStorage.read(key: _expirationKey);
    return expirationString != null ? DateTime.parse(expirationString!) : null;
  }
  
  @override
  Future<void> saveTokenExpiration(DateTime expiration) async {
    await _secureStorage.write(
      key: _expirationKey,
      value: expiration.toIso8601String(),
    );
  }
}
```

## Data Model Patterns

### Base Model
```dart
abstract class BaseModel {
  String get id;
  DateTime get createdAt;
  DateTime? get updatedAt;
  
  Map<String, dynamic> toJson();
  
  static T fromJson<T extends BaseModel>(Map<String, dynamic> json);
}

class Model extends BaseModel {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  const Model({
    required this.id,
    required this.createdAt,
    this.updatedAt,
  });
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
```

### User Model
```dart
class UserModel extends Model {
  final String email;
  final String name;
  final String role;
  final String? documentType;
  final String? documentNumber;
  final bool isActive;
  
  const UserModel({
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
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      documentType: json['document_type'] as String?,
      documentNumber: json['document_number'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'email': email,
      'name': name,
      'role': role,
      'document_type': documentType,
      'document_number': documentNumber,
      'is_active': isActive,
    };
  }
  
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? documentType,
    String? documentNumber,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
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

### Transaction Model
```dart
class TransactionModel extends Model {
  final String customerId;
  final String customerName;
  final int points;
  final String description;
  final String type;
  final String status;
  final String? branchId;
  
  const TransactionModel({
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
  
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String,
      points: json['points'] as int,
      description: json['description'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      branchId: json['branch_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'customer_id': customerId,
      'customer_name': customerName,
      'points': points,
      'description': description,
      'type': type,
      'status': status,
      'branch_id': branchId,
    };
  }
}
```

## Mapper Patterns

### Base Mapper
```dart
abstract class Mapper<Entity extends BaseModel, Model extends BaseModel> {
  Entity toEntity(Model model);
  Model toModel(Entity entity);
}
```

### User Mapper
```dart
class UserMapper implements Mapper<UserEntity, UserModel> {
  @override
  UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      role: _stringToUserRole(model.role),
      documentType: model.documentType,
      documentNumber: model.documentNumber,
      isActive: model.isActive,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
  
  @override
  UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      role: _userRoleToString(entity.role),
      documentType: entity.documentType,
      documentNumber: entity.documentNumber,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
  
  UserRole _stringToUserRole(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'manager':
        return UserRole.manager;
      case 'worker':
        return UserRole.worker;
      case 'viewer':
        return UserRole.viewer;
      default:
        return UserRole.viewer;
    }
  }
  
  String _userRoleToString(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'admin';
      case UserRole.manager:
        return 'manager';
      case UserRole.worker:
        return 'worker';
      case UserRole.viewer:
        return 'viewer';
    }
  }
}
```

### Transaction Mapper
```dart
class TransactionMapper implements Mapper<TransactionEntity, TransactionModel> {
  @override
  TransactionEntity toEntity(TransactionModel model) {
    return TransactionEntity(
      id: model.id,
      customerId: model.customerId,
      customerName: model.customerName,
      points: model.points,
      description: model.description,
      type: _stringToTransactionType(model.type),
      status: _stringToTransactionStatus(model.status),
      branchId: model.branchId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
  
  @override
  TransactionModel toModel(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      customerId: entity.customerId,
      customerName: entity.customerName,
      points: entity.points,
      description: entity.description,
      type: _transactionTypeToString(entity.type),
      status: _transactionStatusToString(entity.status),
      branchId: entity.branchId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
  
  TransactionType _stringToTransactionType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'debit':
        return TransactionType.debit;
      case 'credit':
        return TransactionType.credit;
      default:
        return TransactionType.debit;
    }
  }
  
  String _transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.debit:
        return 'debit';
      case TransactionType.credit:
        return 'credit';
    }
  }
  
  TransactionStatus _stringToTransactionStatus(String statusString) {
    switch (statusString.toLowerCase()) {
      case 'pending':
        return TransactionStatus.pending;
      case 'completed':
        return TransactionStatus.completed;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }
  
  String _transactionStatusToString(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return 'pending';
      case TransactionStatus.completed:
        return 'completed';
      case TransactionStatus.failed:
        return 'failed';
    }
  }
}
```

## Repository Implementation Patterns

### Auth Repository Implementation
```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthSecureDataSource _secureDataSource;
  final UserMapper _mapper;
  
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthSecureDataSource secureDataSource,
    required UserMapper mapper,
  }) : _remoteDataSource = remoteDataSource,
       _secureDataSource = secureDataSource,
       _mapper = mapper;
  
  @override
  Future<Either<AuthFailure, User>> login({
    required String documentType,
    required String documentNumber,
    required String password,
  }) async {
    try {
      final userData = await _remoteDataSource.login(
        documentType: documentType,
        documentNumber: documentNumber,
        password: password,
      );
      
      // Save token
      final token = userData['token'] as String;
      final expiration = DateTime.parse(userData['expires_at'] as String);
      
      await _secureDataSource.saveToken(token);
      await _secureDataSource.saveTokenExpiration(expiration);
      
      // Convert to domain entity
      final userModel = UserModel.fromJson(userData['user'] as Map<String, dynamic>);
      final userEntity = _mapper.toEntity(userModel);
      
      return Right(userEntity);
    } on ServerException catch (e) {
      return Left(AuthFailure.custom(e.message));
    } catch (e) {
      return Left(AuthFailure.networkError);
    }
  }
  
  @override
  Future<Either<AuthFailure, User?>> getCurrentUser() async {
    try {
      final token = await _secureDataSource.getToken();
      if (token == null) {
        return Right(null);
      }
      
      final expiration = await _secureDataSource.getTokenExpiration();
      if (expiration != null && expiration.isBefore(DateTime.now())) {
        await logout();
        return const Right(null);
      }
      
      final userData = await _remoteDataSource.getCurrentUser();
      if (userData == null) {
        return const Right(null);
      }
      
      final userModel = UserModel.fromJson(userData);
      final userEntity = _mapper.toEntity(userModel);
      
      return Right(userEntity);
    } on ServerException catch (e) {
      return Left(AuthFailure.custom(e.message));
    } catch (e) {
      return Left(AuthFailure.networkError);
    }
  }
  
  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _secureDataSource.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure.networkError);
    }
  }
}
```

### Transaction Repository Implementation
```dart
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;
  final TransactionLocalDataSource _localDataSource;
  final TransactionMapper _mapper;
  
  TransactionRepositoryImpl({
    required TransactionRemoteDataSource remoteDataSource,
    required TransactionLocalDataSource localDataSource,
    required TransactionMapper mapper,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _mapper = mapper;
  
  @override
  Future<Either<TransactionFailure, List<Transaction>>> getTransactions({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  }) async {
    try {
      // Try local first, then remote
      final localModels = await _localDataSource.getTransactions(
        branchId: branchId,
        startDate: startDate,
        endDate: endDate,
      );
      
      if (localModels.isNotEmpty) {
        final entities = localModels.map((model) => _mapper.toEntity(model)).toList();
        return Right(entities);
      }
      
      // Fallback to remote
      final remoteData = await _remoteDataSource.getTransactions(
        branchId: branchId,
        startDate: startDate,
        endDate: endDate,
        type: type,
      );
      
      final models = remoteData.map((json) => TransactionModel.fromJson(json)).toList();
      final entities = models.map((model) => _mapper.toEntity(model)).toList();
      
      // Cache locally
      for (final model in models) {
        await _localDataSource.saveTransaction(model);
      }
      
      return Right(entities);
    } on ServerException catch (e) {
      return Left(TransactionFailure.custom(e.message));
    } catch (e) {
      return Left(TransactionFailure.custom('Unexpected error: $e'));
    }
  }
}
```

## Exception Handling

### Server Exception
```dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  
  const ServerException({required this.message, this.statusCode});
  
  factory ServerException.fromDioException(DioException exception) {
    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout) {
      return const ServerException(message: 'Connection timeout');
    }
    
    if (exception.type == DioExceptionType.connectionError) {
      return const ServerException(message: 'No internet connection');
    }
    
    if (exception.response != null) {
      return ServerException(
        message: exception.response?.data?['message'] ?? 'Server error',
        statusCode: exception.response?.statusCode,
      );
    }
    
    return ServerException(message: exception.message ?? 'Unknown error');
  }
}

class CacheException implements Exception {
  final String message;
  
  const CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  
  const NetworkException(this.message);
}
```

## File Organization

```
lib/features/feature_name/data/
├── datasources/
│   ├── remote/
│   │   ├── feature_remote_datasource.dart
│   │   └── feature_remote_datasource_impl.dart
│   ├── local/
│   │   ├── feature_local_datasource.dart
│   │   └── feature_local_datasource_impl.dart
│   └── secure/
│       ├── feature_secure_datasource.dart
│       └── feature_secure_datasource_impl.dart
├── models/
│   ├── feature_model.dart
│   └── base_model.dart
├── mappers/
│   ├── feature_mapper.dart
│   └── base_mapper.dart
├── repositories/
│   ├── feature_repository_impl.dart
│   └── base_repository_impl.dart
├── exceptions/
│   ├── server_exception.dart
│   ├── cache_exception.dart
│   └── network_exception.dart
└── data.dart // barrel export
```

## Testing Data Layer

### Mock Data Source
```dart
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDataSource mockRemoteDataSource;
    late MockAuthSecureDataSource mockSecureDataSource;
    late UserMapper mockMapper;
    
    setUp(() {
      mockRemoteDataSource = MockAuthRemoteDataSource();
      mockSecureDataSource = MockAuthSecureDataSource();
      mockMapper = UserMapper();
      
      repository = AuthRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        secureDataSource: mockSecureDataSource,
        mapper: mockMapper,
      );
    });
    
    test('should return user on successful login', () async {
      // Arrange
      const loginParams = {
        'document_type': 'dni',
        'document_number': '12345678',
        'password': 'password123',
      };
      
      final userData = {
        'token': 'test_token',
        'expires_at': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
        'user': {
          'id': '1',
          'email': 'test@example.com',
          'name': 'Test User',
          'role': 'worker',
        },
      };
      
      when(() => mockRemoteDataSource.login(any()))
          .thenAnswer((_) async => userData);
      
      // Act
      final result = await repository.login(
        documentType: 'dni',
        documentNumber: '12345678',
        password: 'password123',
      );
      
      // Assert
      expect(result.isRight, true);
      expect(result.right?.email, equals('test@example.com'));
      verify(() => mockSecureDataSource.saveToken('test_token')).called(1);
    });
  });
}
```

## Related Skills

- `partners` - Project overview and navigation
- `partners-domain` - Domain layer contracts
- `partners-testing` - Testing patterns
- `dio-networking` - HTTP client patterns
- `clean-architecture` - Clean Architecture principles