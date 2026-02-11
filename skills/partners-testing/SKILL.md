---
name: partners-testing
description: >
  Testing patterns for Partners app - unit tests, widget tests, integration tests.
  Trigger: Writing tests, setting up test infrastructure, test coverage.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [test]
  auto_invoke:
    - "Writing tests"
    - "Setting up test infrastructure"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Testing Overview

Partners app follows a comprehensive testing strategy with unit, widget, and integration tests.

**Agentes por tipo de test (orden):** Para un solo tipo, invocar el skill correspondiente: **1)** [partners-testing-unit](../partners-testing-unit/SKILL.md) (unit), **2)** [partners-testing-widget](../partners-testing-widget/SKILL.md) (widget), **3)** [partners-testing-integration](../partners-testing-integration/SKILL.md) (integration). Este archivo es el paraguas y define la estrategia general.

## Matriz de casos (referencia: login)

Para un flujo como login, cubrir la **mayoría de casos posibles** en las tres capas (unit, widget, integration) para detectar fallos y evitar regresiones.

| Caso | Unit (Cubit / UseCase) | Widget (pantalla) | Integration (E2E) |
|------|------------------------|-------------------|-------------------|
| **Estado inicial** | Estado initial del Cubit | Formulario y textos visibles | App muestra login al arrancar sin sesión |
| **Campos vacíos** | (validación en UI) | SnackBar "ingrese email y contraseña"; no se llama login | SnackBar al enviar vacío |
| **Email inválido (regex)** | (validación en UI) | SnackBar "formato email no válido"; no se llama login | SnackBar con email sin @ |
| **Credenciales incorrectas** | Cubit emite failure con errorMessage; UseCase retorna Left(mensaje) | Estado failure → SnackBar con mensaje de error | Credenciales incorrectas → se permanece en login |
| **Usuario no encontrado / Contraseña incorrecta** | Cubit emite failure con mensaje distinto | (mismo: SnackBar con error) | (API devuelve mensaje; opcional assert) |
| **Login exitoso** | Cubit emite success con responseEntity; UseCase retorna Right | Estado success → no se muestra mensaje de error | Con credenciales válidas (entorno test) → navegación a dashboard |
| **Loading** | No doble llamada si ya loading | Botón muestra CircularProgressIndicator | — |
| **Reset** | reset() emite estado inicial | — | — |

Reglas al diseñar tests: **romper la app** (casos límite), **errores en UI** (todos los mensajes que ve el usuario), **navegación** (éxito → dashboard en E2E si aplica), **Cubit** (todos los estados y mensajes que emite).

## Matriz de casos (register)

Flujo: Login → "Regístrese gratis" → RegisterScreen → (RUC 10/15/20, validación RUC, documento para RUC 20, Continuar → validación).

| Caso | Unit (UseCase / Cubit) | Widget (RegisterScreen) | Integration (E2E) |
|------|------------------------|-------------------------|-------------------|
| **Estado inicial** | RegisterStateX.initial(); SendRuc/SendDoc/StartRegister use cases | Título, RUC 10/15/20, campo RUC, botón Continuar deshabilitado | — |
| **RUC inválido (formato)** | SendRucUsecase retorna Left(Ruc no valido); longitud/prefijo incorrecto | — | — |
| **RUC válido (10/20)** | SendRucUsecase retorna Right(RegisterResponseEntity); RUC 20 válido | — | — |
| **Documento inválido / sesionId vacío** | SendDocumentUsecase retorna Left (formato DNI / sesión vacía) | — | — |
| **StartRegister fallo/éxito** | StartRegisterUsecase Right/Left | — | — |
| **sendRuc loading/success/failure** | Cubit emite loading→success (guarda sessionId); loading→failure (errorMessage); no doble llamada en loading | Indicador carga en campo RUC; botón habilitado tras success + listener | — |
| **sendDocumendt loading/success/failure** | Cubit emite loading→success/failure; no doble llamada en loading | Indicador carga en campo doc (RUC 20) | — |
| **submitStart loading/success/failure** | Cubit emite loading→success/failure; no doble llamada en loading | — | — |
| **Reset** | reset() emite RegisterStateX.initial(); no mantiene datos previos | Al tocar RUC 15/20 se llama cubit.reset() | — |
| **Errores backend / datos incorrectos** | Cubit emite failure con errorMessage | sendRuc/sendDoc/sendStart failure → SnackBar con mensaje + error en campo RUC/doc (setRucErrorFromBackend/setDocErrorFromBackend); sin mensaje → SnackBar con defaultErrorSnackBar | — |
| **Navegación** | — | — | Login → Regístrese gratis → pantalla registro; botón Continuar deshabilitado; RUC 20 muestra campo doc; Regresar vuelve a login |

**Errores en UI (register):** El listener de `RegisterCubit` debe reaccionar a `sendRucStatus`/`sendDocStatus`/`sendStartStatus` == failure: mostrar SnackBar con `state.errorMessage` (o mensaje por defecto) y, para RUC/doc, llamar a `setRucErrorFromBackend`/`setDocErrorFromBackend` para que el campo muestre el error. Así se evita que el usuario no vea respuestas del backend o datos incorrectos.

Archivos de referencia: `test/features/auth/register/` (unit: use_case/, presentation/cubit/), `test/features/auth/register/presentation/screens/register_screen_test.dart`, `integration_test/register_flow_test.dart`. Keys/strings: `RegisterScreenKeys`, `RegisterScreenStrings`.

## Testing Stack

- **flutter_test**: Core testing framework
- **bloc_test**: BLoC/Cubit testing
- **mocktail**: Mocking framework
- **integration_test**: E2E testing
- **golden_tests**: Visual regression testing

## Test Organization

```
test/
├── unit/
│   ├── domain/
│   │   ├── use_cases/
│   │   ├── entities/
│   │   └── repositories/
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   ├── mappers/
│   │   └── repositories/
│   └── presentation/
│       ├── cubits/
│       └── providers/
├── widget/
│   ├── screens/
│   ├── widgets/
│   └── components/
├── integration/
│   ├── flows/
│   └── scenarios/
└── helpers/
    ├── test_helpers.dart
    ├── mock_data.dart
    └── test_fixtures.dart
```

## Unit Testing Patterns

### Use Case Testing
```dart
// test/unit/domain/use_cases/login_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:partners/features/auth/domain/use_cases/login_usecase.dart';
import 'package:partners/features/auth/domain/repositories/auth_repository.dart';
import 'package:partners/features/auth/domain/entities/user_entity.dart';
import 'package:partners/features/auth/domain/failures/auth_failure.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepository;
    
    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(mockRepository);
    });
    
    test('should return user on successful login', () async {
      // Arrange
      const params = LoginParams(
        documentType: 'dni',
        documentNumber: '12345678',
        password: 'password123',
      );
      
      final expectedUser = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.worker,
        createdAt: DateTime.now(),
      );
      
      when(() => mockRepository.login(any()))
          .thenAnswer((_) async => Right(expectedUser));
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isRight, true);
      expect(result.right, equals(expectedUser));
      verify(() => mockRepository.login(params)).called(1);
    });
    
    test('should return failure on invalid credentials', () async {
      // Arrange
      const params = LoginParams(
        documentType: 'dni',
        documentNumber: '12345678',
        password: 'wrong',
      );
      
      when(() => mockRepository.login(any()))
          .thenAnswer((_) async => Left(AuthFailure.invalidCredentials));
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isLeft, true);
      expect(result.left, equals(AuthFailure.invalidCredentials));
      verify(() => mockRepository.login(params)).called(1);
    });
    
    test('should validate input parameters', () async {
      // Arrange
      const params = LoginParams(
        documentType: '',
        documentNumber: '',
        password: '',
      );
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isLeft, true);
      expect(result.left, equals(AuthFailure.invalidCredentials));
      verifyNever(() => mockRepository.login(any()));
    });
  });
}
```

### Repository Testing
```dart
// test/unit/data/repositories/auth_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:partners/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:partners/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:partners/features/auth/data/datasources/auth_secure_datasource.dart';
import 'package:partners/features/auth/data/mappers/user_mapper.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthSecureDataSource extends Mock implements AuthSecureDataSource {}

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDataSource mockRemoteDataSource;
    late MockAuthSecureDataSource mockSecureDataSource;
    late UserMapper mapper;
    
    setUp(() {
      mockRemoteDataSource = MockAuthRemoteDataSource();
      mockSecureDataSource = MockAuthSecureDataSource();
      mapper = UserMapper();
      
      repository = AuthRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        secureDataSource: mockSecureDataSource,
        mapper: mapper,
      );
    });
    
    test('should save token on successful login', () async {
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
      when(() => mockSecureDataSource.saveToken(any())).thenAnswer((_) async {});
      when(() => mockSecureDataSource.saveTokenExpiration(any())).thenAnswer((_) async {});
      
      // Act
      final result = await repository.login(
        documentType: 'dni',
        documentNumber: '12345678',
        password: 'password123',
      );
      
      // Assert
      expect(result.isRight, true);
      verify(() => mockSecureDataSource.saveToken('test_token')).called(1);
      verify(() => mockSecureDataSource.saveTokenExpiration(any())).called(1);
    });
  });
}
```

### Mapper Testing
```dart
// test/unit/data/mappers/user_mapper_test.dart
import 'package:flutter_test/flutter_test.dart';

import 'package:partners/features/auth/data/mappers/user_mapper.dart';
import 'package:partners/features/auth/data/models/user_model.dart';
import 'package:partners/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserMapper', () {
    late UserMapper mapper;
    
    setUp(() {
      mapper = UserMapper();
    });
    
    test('should convert model to entity correctly', () {
      // Arrange
      final model = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        role: 'worker',
        createdAt: DateTime.now(),
      );
      
      // Act
      final entity = mapper.toEntity(model);
      
      // Assert
      expect(entity.id, equals(model.id));
      expect(entity.email, equals(model.email));
      expect(entity.name, equals(model.name));
      expect(entity.role, equals(UserRole.worker));
    });
    
    test('should convert entity to model correctly', () {
      // Arrange
      final entity = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.worker,
        createdAt: DateTime.now(),
      );
      
      // Act
      final model = mapper.toModel(entity);
      
      // Assert
      expect(model.id, equals(entity.id));
      expect(model.email, equals(entity.email));
      expect(model.name, equals(entity.name));
      expect(model.role, equals('worker'));
    });
  });
}
```

## Widget Testing Patterns

### Screen Testing
```dart
// test/widget/screens/login_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:partners/features/auth/presentation/screens/login_screen.dart';
import 'package:partners/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:partners/features/auth/presentation/cubit/auth_state.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  group('LoginScreen', () {
    late MockAuthCubit mockCubit;
    
    setUp(() {
      mockCubit = MockAuthCubit();
    });
    
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockCubit,
          child: LoginScreen(),
        ),
      );
    }
    
    testWidgets('should display login form', (WidgetTester tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(AuthState.initial());
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Assert
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3)); // document, number, password
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
    
    testWidgets('should show loading indicator when submitting', (WidgetTester tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(AuthState.initial());
      when(() => mockCubit.state).thenReturn(AuthState.loading());
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    
    testWidgets('should show error message on login failure', (WidgetTester tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(AuthState.initial());
      when(() => mockCubit.state).thenReturn(AuthState.failure('Invalid credentials'));
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
    
    testWidgets('should call login when form is submitted', (WidgetTester tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(AuthState.initial());
      when(() => mockCubit.login(any(), any(), any())).thenAnswer((_) async {});
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Fill form
      await tester.enterText(find.byKey(Key('document_type_field')), 'DNI');
      await tester.enterText(find.byKey(Key('document_number_field')), '12345678');
      await tester.enterText(find.byKey(Key('password_field')), 'password123');
      
      // Submit form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // Assert
      verify(() => mockCubit.login('DNI', '12345678', 'password123')).called(1);
    });
  });
}
```

### Widget Testing
```dart
// test/widget/widgets/custom_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:partners/core/widgets/custom_button.dart';

void main() {
  group('CustomButton', () {
    testWidgets('should display text correctly', (WidgetTester tester) async {
      // Arrange
      const buttonText = 'Test Button';
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text(buttonText), findsOneWidget);
    });
    
    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();
      
      // Assert
      expect(wasPressed, isTrue);
    });
    
    testWidgets('should be disabled when onPressed is null', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled Button',
              onPressed: null,
            ),
          ),
        ),
      );
      
      // Assert
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
    
    testWidgets('should show loading indicator when isLoading is true', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Loading Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading Button'), findsNothing);
    });
  });
}
```

## BLoC/Cubit Testing

### Cubit Testing
```dart
// test/unit/presentation/cubits/auth_cubit_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:partners/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:partners/features/auth/presentation/cubit/auth_state.dart';
import 'package:partners/features/auth/domain/use_cases/login_usecase.dart';
import 'package:partners/features/auth/domain/entities/user_entity.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  group('AuthCubit', () {
    late AuthCubit cubit;
    late MockLoginUseCase mockLoginUseCase;
    
    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      cubit = AuthCubit(mockLoginUseCase);
    });
    
    tearDown(() {
      cubit.close();
    });
    
    test('initial state is AuthState.initial', () {
      expect(cubit.state, equals(AuthState.initial()));
    });
    
    blocTest<AuthCubit, AuthState>(
      'should emit loading and success states on successful login',
      build: () {
        when(() => mockLoginUseCase.call(any()))
            .thenAnswer((_) async => Right(UserEntity(
              id: '1',
              email: 'test@example.com',
              name: 'Test User',
              role: UserRole.worker,
              createdAt: DateTime.now(),
            )));
        return cubit;
      },
      act: (cubit) => cubit.login('dni', '12345678', 'password123'),
      expect: () => [
        AuthState.loading(),
        AuthState.success(UserEntity(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          role: UserRole.worker,
          createdAt: DateTime.now(),
        )),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase.call(any())).called(1);
      },
    );
    
    blocTest<AuthCubit, AuthState>(
      'should emit loading and failure states on login failure',
      build: () {
        when(() => mockLoginUseCase.call(any()))
            .thenAnswer((_) async => Left(AuthFailure.invalidCredentials));
        return cubit;
      },
      act: (cubit) => cubit.login('dni', '12345678', 'wrong'),
      expect: () => [
        AuthState.loading(),
        AuthState.failure('Invalid credentials'),
      ],
    );
  });
}
```

## Integration Testing

### Flow Testing
```dart
// integration_test/auth_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:partners/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Authentication Flow', () {
    testWidgets('complete login flow', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();
      
      // Act & Assert - Navigate to login
      expect(find.text('Welcome'), findsOneWidget);
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Fill login form
      await tester.enterText(find.byKey(Key('document_type_field')), 'DNI');
      await tester.enterText(find.byKey(Key('document_number_field')), '12345678');
      await tester.enterText(find.byKey(Key('password_field')), 'password123');
      
      // Submit form
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(Duration(seconds: 3));
      
      // Verify successful login
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Welcome, Test User'), findsOneWidget);
    });
    
    testWidgets('login with invalid credentials shows error', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Fill with invalid credentials
      await tester.enterText(find.byKey(Key('document_type_field')), 'DNI');
      await tester.enterText(find.byKey(Key('document_number_field')), '12345678');
      await tester.enterText(find.byKey(Key('password_field')), 'wrong');
      
      // Submit form
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Verify error message
      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(find.text('Dashboard'), findsNothing);
    });
  });
}
```

## Test Helpers and Fixtures

### Test Data Factory
```dart
// test/helpers/test_fixtures.dart
import 'package:partners/features/auth/domain/entities/user_entity.dart';
import 'package:partners/features/auth/data/models/user_model.dart';

class TestFixtures {
  static UserEntity get testUser => UserEntity(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    role: UserRole.worker,
    createdAt: DateTime.now(),
  );
  
  static UserModel get testUserModel => UserModel(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    role: 'worker',
    createdAt: DateTime.now(),
  );
  
  static List<UserEntity> get testUsers => [
    testUser,
    UserEntity(
      id: '2',
      email: 'admin@example.com',
      name: 'Admin User',
      role: UserRole.admin,
      createdAt: DateTime.now(),
    ),
  ];
}
```

### Test Helpers
```dart
// test/helpers/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

class TestHelpers {
  static Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }
  
  static Future<void> pumpAndSettleWithDelay(
    WidgetTester tester, {
    Duration delay = const Duration(milliseconds: 100),
  }) async {
    await tester.pump();
    await tester.pump(delay);
  }
  
  static void verifyBlocStates<T extends BlocBase, S>(
    BlocMock blocMock,
    List<S> expectedStates,
  ) {
    for (int i = 0; i < expectedStates.length; i++) {
      verify(() => blocMock.emit(expectedStates[i])).called(1);
    }
  }
}
```

## Golden Testing

### Widget Golden Tests
```dart
// test/widget/widgets/custom_button_golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:partners/core/widgets/custom_button.dart';

void main() {
  group('CustomButton Golden Tests', () {
    testWidgets('default button appearance', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: Center(
              child: CustomButton(
                text: 'Test Button',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      
      await expectLater(
        find.byType(CustomButton),
        matchesGoldenFile('goldens/custom_button_default.png'),
      );
    });
    
    testWidgets('disabled button appearance', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: Center(
              child: CustomButton(
                text: 'Disabled Button',
                onPressed: null,
              ),
            ),
          ),
        ),
      );
      
      await expectLater(
        find.byType(CustomButton),
        matchesGoldenFile('goldens/custom_button_disabled.png'),
      );
    });
    
    testWidgets('loading button appearance', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: Center(
              child: CustomButton(
                text: 'Loading Button',
                onPressed: () {},
                isLoading: true,
              ),
            ),
          ),
        ),
      );
      
      await expectLater(
        find.byType(CustomButton),
        matchesGoldenFile('goldens/custom_button_loading.png'),
      );
    });
  });
}
```

## Test Configuration

### Test Setup
```dart
// test/test_setup.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void setupTestEnvironment() {
  // Configure mocktail
  registerFallbackValue(LoginParams(
    documentType: 'dni',
    documentNumber: '12345678',
    password: 'password123',
  ));
  
  // Global test configuration
  TestWidgetsFlutterBinding.ensureInitialized();
}
```

### Test Commands
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/domain/use_cases/login_usecase_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Run golden tests
flutter test --update-goldens

# Run tests with specific tags
flutter test --tags=unit
flutter test --tags=widget
flutter test --tags=integration
```

## Coverage Reports

### Coverage Configuration
```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  test_coverage: ^0.2.0
```

### Coverage Script
```bash
#!/bin/bash
# scripts/test_coverage.sh

echo "Running tests with coverage..."
flutter test --coverage

echo "Generating coverage report..."
genhtml coverage/lcov.info -o coverage/html

echo "Coverage report generated at coverage/html/index.html"
```

## Related Skills

- `partners` - Project overview and navigation
- `partners-domain` - Domain layer testing
- `partners-data` - Data layer testing
- `partners-ui` - UI component testing
- `testing-flutter` - General Flutter testing patterns
- `bloc-test` - BLoC/Cubit testing patterns