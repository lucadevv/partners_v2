---
name: partners-auth
description: >
  Authentication patterns for Partners app - document validation, RBAC, secure storage.
  Trigger: Creating/modifying authentication flows, working with document validation (DNI, CE, RUC).
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [auth, core]
  auto_invoke:
    - "Creating/modifying authentication flows"
    - "Working with document validation (DNI, CE, RUC)"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## File Conventions (Auth feature)

```
lib/features/auth/
├── auth.dart
├── domain/                  # Login/register entities, repos, use cases, forms, factory
├── data/                    # Auth datasources, models, mappers, repo impl
├── presentation/            # Login/register cubits, screens, notifier, widgets
├── validation/              # Subfeature: email, whatsapp, password, business steps
├── document_scan/
├── forgot_password/
├── otp/
└── registration_success/
```

- Prefer single layer for login + register (no auth/login/ or auth/register/ with their own domain/data/presentation).
- Orchestrator cubit in `presentation/cubit/`.

## Flujo por capas (referencia: register)

- **Domain (UseCase)**: validaciones de dominio (ej. RUC, documento) con `return Left(ValidationException(...))`; luego llama al repositorio y retorna `Either`. Nunca hace `fold`.
- **Presentation (Cubit)**: llama al UseCase y **aquí se hace el fold** del resultado (emit failure con getErrorMessage o success). Ver `RegisterCubit`, `LoginCubit`.
- **Data**: datasource y repository impl retornan Either; repo impl usa `.map(mapper)`. Sin fold.

## Authentication Overview

Partners app supports multi-document authentication with role-based access control (RBAC).

## Document Types Supported

| Type | Validation Pattern | Example |
|-------|------------------|----------|
| DNI | 8 digits | `12345678` |
| CE | 9 digits + letter | `123456789A` |
| RUC | 11 digits | `12345678901` |

## Key Components

### Validation Strategies
- **RucStrategy**: RUC document validation
- **DocValidatorStrategy**: Generic document validation
- **RucConfigFactory**: Configuration for RUC validation
- **DocConfigFactory**: Configuration for document validation

### Auth Flow Components
- **LoginScreen**: Authentication interface
- **RegisterFormNotifier**: Complex form with ChangeNotifier
- **TokenManager**: Secure token management
- **AuthManager**: Authentication state management

### Document Recognition
- **ML Kit**: Text recognition from camera
- **DocumentFrameWidget**: Camera overlay for document scanning
- **DocumentValidation**: Real-time validation feedback

## Security Patterns

### Secure Storage
```dart
// Use Flutter Secure Storage for sensitive data
final _secureStorage = FlutterSecureStorage();
await _secureStorage.write(key: 'token', value: token);
```

### Token Management
```dart
// Token storage with expiration
class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenTypeKey = 'token_type';
  
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
  }) async {
    await _secureStorage.write(key: _tokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    await _secureStorage.write(key: _tokenTypeKey, value: tokenType);
  }
  
  Future<AuthTokens?> getTokens() async {
    final accessToken = await _secureStorage.read(key: _tokenKey);
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    final tokenType = await _secureStorage.read(key: _tokenTypeKey);
    
    if (accessToken == null || refreshToken == null || tokenType == null) {
      return null;
    }
    
    return AuthTokens(
      accessToken: accessToken!,
      refreshToken: refreshToken!,
      tokenType: tokenType!,
    );
  }
  
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _tokenTypeKey);
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });
}
```

### RBAC Implementation
```dart
// Role-based permission checking
enum UserRole { 
  superadmin, 
  branch_manager, 
  employee 
}

class RBAC {
  static bool canAccess(UserRole role, String resource) {
    final permissions = {
      UserRole.superadmin: ['*'],
      UserRole.branch_manager: ['branches', 'transactions', 'reports'],
      UserRole.employee: ['transactions', 'qr'],
    };
    
    return permissions[role]?.contains(resource) ?? false;
  }
  
  static bool hasRoleAccess(UserRole currentUserRole, UserRole requiredRole) {
    final roleHierarchy = {
      UserRole.employee: 1,
      UserRole.branch_manager: 2,
      UserRole.superadmin: 3,
    };
    
    return roleHierarchy[currentRole]! >= roleHierarchy[requiredRole]!;
  }
}
```

## Login API Integration

### Login Use Case with API Integration
```dart
class LoginUseCase implements UseCase<LoginResponse, LoginParams> {
  final AuthRepository _authRepository;
  final TokenManager _tokenManager;
  
  LoginUseCase(this._authRepository, this._tokenManager);
  
  @override
  Future<Either<AuthFailure, LoginResponse>> call(LoginParams params) async {
    // Validate input
    final validationError = _validateLoginParams(params);
    if (validationError != null) {
      return Left(AuthFailure.invalidInput(validationError));
    }
    
    try {
      // Call login API
      final result = await _authRepository.login(
        email: params.email,
        password: params.password,
      );
      
      return result.fold(
        (failure) => Left(failure),
        (response) async {
          // Store tokens securely
          await _tokenManager.saveTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            tokenType: response.tokenType,
          );
          
          // Extract and store user role
          final userRole = _mapRoleFromApi(response.role);
          
          return Right(LoginResponse(
            user: response.user.copyWith(role: userRole),
            message: response.message,
          ));
        },
      );
    } catch (e) {
      return Left(AuthFailure.networkError(e.toString()));
    }
  }
  
  String? _validateLoginParams(LoginParams params) {
    if (params.email.trim().isEmpty) {
      return 'El correo electrónico es requerido';
    }
    
    if (!EmailValidator.isValid(params.email)) {
      return 'El correo electrónico no es válido';
    }
    
    if (params.password.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    
    return null;
  }
  
  UserRole _mapRoleFromApi(String apiRole) {
    switch (apiRole.toLowerCase()) {
      case 'admin':
        return UserRole.superadmin;
      case 'branch_manager':
        return UserRole.branch_manager;
      case 'employee':
        return UserRole.employee;
      default:
        return UserRole.employee; // Default role
    }
  }
}
```

### Auth Repository Implementation
```dart
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final String _baseUrl;
  
  AuthRepositoryImpl({
    required Dio dio,
    required String baseUrl,
  }) : _dio = dio, _baseUrl = baseUrl;
  
  @override
  Future<Either<AuthFailure, LoginApiResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        // Extract only needed fields from API response
        final loginData = LoginApiResponse(
          message: data['message'] ?? 'Login exitoso',
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          tokenType: data['token_type'] ?? 'Bearer',
          user: UserEntity(
            id: data['user']['id'],
            email: data['user']['email'],
            name: _extractFullName(data['user']),
            role: data['user']['id'], // Will be mapped in use case
            createdAt: DateTime.parse(data['user']['created_at']),
          ),
        );
        
        return Right(loginData);
      } else {
        return Left(AuthFailure.invalidCredentials('Credenciales inválidas'));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(AuthFailure.networkError(e.toString()));
    }
  }
  
  String _extractFullName(Map<String, dynamic> userData) {
    final person = userData['person'] as Map<String, dynamic>?;
    final name = person?['name'] as String? ?? '';
    final lastName = person?['last_name'] as String? ?? '';
    return '$name $lastName'.trim();
  }
  
  AuthFailure _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AuthFailure.networkTimeout('Tiempo de conexión agotado');
        
      case DioExceptionType.connectionError:
        return AuthFailure.networkError('Error de conexión');
        
      case DioExceptionType.badResponse:
        if (exception.response?.statusCode == 401) {
          return AuthFailure.invalidCredentials('Credenciales inválidas');
        }
        return AuthFailure.serverError('Error del servidor: ${exception.response?.statusCode}');
        
      default:
        return AuthFailure.unknownError('Error desconocido: ${exception.message}');
    }
  }
}
```

## Login Screen Implementation

### LoginScreen with ChangeNotifier
```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginFormNotifier _formNotifier;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _formNotifier = LoginFormNotifier();
    _formNotifier.addListener(_onFormChanged);
  }
  
  @override
  void dispose() {
    _formNotifier.removeListener(_onFormChanged);
    _formNotifier.dispose();
    super.dispose();
  }
  
  void _onFormChanged() {
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo o título
                  Text(
                    'Partners App',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 48),
                  
                  // Email field
                  CustomTextFormField(
                    controller: _formNotifier.emailController,
                    labelText: 'Correo Electrónico',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                    prefixIcon: Icons.email_outlined,
                  ),
                  SizedBox(height: 16),
                  
                  // Password field
                  CustomTextFormField(
                    controller: _formNotifier.passwordController,
                    labelText: 'Contraseña',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: _validatePassword,
                    prefixIcon: Icons.lock_outlined,
                  ),
                  SizedBox(height: 24),
                  
                  // Error message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                  
                  // Login button
                  CustomButton(
                    text: 'Iniciar Sesión',
                    onPressed: _formNotifier.isFormValid && !_isLoading 
                        ? _handleLogin 
                        : null,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 16),
                  
                  // Forgot password link
                  TextButton(
                    onPressed: _handleForgotPassword,
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    
    if (!EmailValidator.isValid(value)) {
      return 'El correo electrónico no es válido';
    }
    
    return null;
  }
  
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    
    return null;
  }
  
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() => _isLoading = true);
    setState(() => _errorMessage = null);
    
    try {
      final result = await GetIt.instance<LoginUseCase>()(
        LoginParams(
          email: _formNotifier.emailController.text.trim(),
          password: _formNotifier.passwordController.text,
        ),
      );
      
      result.fold(
        (failure) {
          setState(() => _errorMessage = failure.message);
        },
        (response) {
          // Navigate to main screen
          Navigator.of(context).pushReplacementNamed('/main');
        },
      );
    } catch (e) {
      setState(() => _errorMessage = 'Error inesperado: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  void _handleForgotPassword() {
    // Navigate to forgot password screen
    Navigator.of(context).pushNamed('/forgot-password');
  }
}
```

### Complex Form Notifier
```dart
class LoginFormNotifier extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  String? _emailError;
  String? _passwordError;
  
  // Getters
  bool get isEmailValid => _isEmailValid;
  bool get isPasswordValid => _isPasswordValid;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  
  bool get isFormValid => _isEmailValid && _isPasswordValid;
  
  // Validation methods
  void validateEmail(String value) {
    if (value.isEmpty) {
      _emailError = 'El correo electrónico es requerido';
      _isEmailValid = false;
    } else if (!EmailValidator.isValid(value)) {
      _emailError = 'El correo electrónico no es válido';
      _isEmailValid = false;
    } else {
      _emailError = null;
      _isEmailValid = true;
    }
    notifyListeners();
  }
  
  void validatePassword(String value) {
    if (value.isEmpty) {
      _passwordError = 'La contraseña es requerida';
      _isPasswordValid = false;
    } else if (value.length < 8) {
      _passwordError = 'La contraseña debe tener al menos 8 caracteres';
      _isPasswordValid = false;
    } else {
      _passwordError = null;
      _isPasswordValid = true;
    }
    notifyListeners();
  }
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
```

## Related Skills

- `partners` - Project overview, component navigation
- `partners-ui` - Widget patterns for auth screens
- `partners-domain` - Use cases and entities for auth
- `partners-data` - Data sources for auth
- `partners-testing` - Testing patterns
- `partners-rbac` - Role-based access control
- `state-management` - BLoC/Cubit patterns
- `dio-networking` - HTTP client patterns