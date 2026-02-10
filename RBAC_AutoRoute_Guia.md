# Guía de Implementación: Control de Acceso Basado en Roles (RBAC) con AutoRoute en Flutter

**Fuente:** [Implementing Role-Based Access Control in Flutter UI with GoRouter](https://medium.com/@m.goudjal.y/implementing-role-based-access-control-in-flutter-ui-with-gorouter-df4551c4930f)

**Adaptado para:** AutoRoute (en lugar de GoRouter)

---

## 📋 Tabla de Contenidos

1. [Conceptos Fundamentales de RBAC](#conceptos-fundamentales-de-rbac)
2. [Arquitectura de Roles y Permisos](#arquitectura-de-roles-y-permisos)
3. [Implementación con AutoRoute](#implementación-con-autoroute)
4. [Guards Personalizados para Roles](#guards-personalizados-para-roles)
5. [Gestión de Roles en la Aplicación](#gestión-de-roles-en-la-aplicación)
6. [Ejemplos Prácticos](#ejemplos-prácticos)
7. [Mejores Prácticas](#mejores-prácticas)

---

## 🎯 Conceptos Fundamentales de RBAC

### ¿Qué es RBAC?

**RBAC (Role-Based Access Control)** es un modelo de control de acceso que restringe el acceso del sistema según los roles de los usuarios. En lugar de asignar permisos directamente a usuarios, se asignan roles a usuarios y permisos a roles.

### Componentes Clave

1. **Usuario (User)**: La entidad que necesita acceso al sistema
2. **Rol (Role)**: Un conjunto nombrado de permisos (ej: `admin`, `editor`, `viewer`, `partner`)
3. **Permiso (Permission)**: Una acción específica que se puede realizar (ej: `read:products`, `create:products`, `update:products`, `delete:products`)
4. **Recurso (Resource)**: La entidad sobre la que se aplican los permisos (ej: `products`, `users`, `orders`)

### Ventajas de RBAC

- ✅ **Escalabilidad**: Fácil agregar nuevos roles y permisos
- ✅ **Mantenibilidad**: Cambios centralizados en roles, no en usuarios individuales
- ✅ **Seguridad**: Control granular de acceso
- ✅ **Auditoría**: Fácil rastrear quién tiene acceso a qué

---

## 🏗️ Arquitectura de Roles y Permisos

### Estructura de Datos Recomendada

```dart
// lib/core/models/user_role.dart
enum UserRole {
  admin,      // Acceso completo
  partner,    // Socio/Partner con permisos específicos
  editor,     // Puede editar contenido
  viewer,     // Solo lectura
  guest,      // Acceso limitado
}

// lib/core/models/permission.dart
enum Permission {
  // Productos
  readProducts,
  createProducts,
  updateProducts,
  deleteProducts,
  
  // Usuarios
  readUsers,
  createUsers,
  updateUsers,
  deleteUsers,
  
  // Pedidos
  readOrders,
  createOrders,
  updateOrders,
  cancelOrders,
  
  // Configuración
  readSettings,
  updateSettings,
}

// lib/core/models/role_permissions.dart
class RolePermissions {
  static const Map<UserRole, List<Permission>> rolePermissions = {
    UserRole.admin: [
      Permission.readProducts,
      Permission.createProducts,
      Permission.updateProducts,
      Permission.deleteProducts,
      Permission.readUsers,
      Permission.createUsers,
      Permission.updateUsers,
      Permission.deleteUsers,
      Permission.readOrders,
      Permission.createOrders,
      Permission.updateOrders,
      Permission.cancelOrders,
      Permission.readSettings,
      Permission.updateSettings,
    ],
    UserRole.partner: [
      Permission.readProducts,
      Permission.readOrders,
      Permission.createOrders,
      Permission.updateOrders,
    ],
    UserRole.editor: [
      Permission.readProducts,
      Permission.createProducts,
      Permission.updateProducts,
    ],
    UserRole.viewer: [
      Permission.readProducts,
      Permission.readOrders,
    ],
    UserRole.guest: [
      Permission.readProducts,
    ],
  };

  static List<Permission> getPermissionsForRole(UserRole role) {
    return rolePermissions[role] ?? [];
  }

  static bool hasPermission(UserRole role, Permission permission) {
    return getPermissionsForRole(role).contains(permission);
  }
}
```

---

## 🛠️ Implementación con AutoRoute

### 1. Modelo de Usuario con Rol

```dart
// lib/core/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final List<Permission>? customPermissions; // Permisos personalizados opcionales

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.customPermissions,
  });

  bool hasPermission(Permission permission) {
    // Verificar permisos del rol
    if (RolePermissions.hasPermission(role, permission)) {
      return true;
    }
    
    // Verificar permisos personalizados si existen
    if (customPermissions != null) {
      return customPermissions!.contains(permission);
    }
    
    return false;
  }

  bool hasAnyPermission(List<Permission> permissions) {
    return permissions.any((permission) => hasPermission(permission));
  }

  bool hasAllPermissions(List<Permission> permissions) {
    return permissions.every((permission) => hasPermission(permission));
  }
}
```

### 2. Servicio de Gestión de Roles

```dart
// lib/core/services/role_service.dart
import 'package:partners/core/models/user_model.dart';
import 'package:partners/core/models/role_permissions.dart';

class RoleService {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  void setUser(UserModel user) {
    _currentUser = user;
  }

  void clearUser() {
    _currentUser = null;
  }

  UserRole? get currentRole => _currentUser?.role;

  bool hasPermission(Permission permission) {
    if (_currentUser == null) return false;
    return _currentUser!.hasPermission(permission);
  }

  bool hasAnyPermission(List<Permission> permissions) {
    if (_currentUser == null) return false;
    return _currentUser!.hasAnyPermission(permissions);
  }

  bool hasAllPermissions(List<Permission> permissions) {
    if (_currentUser == null) return false;
    return _currentUser!.hasAllPermissions(permissions);
  }

  bool hasRole(UserRole role) {
    return _currentUser?.role == role;
  }

  bool hasAnyRole(List<UserRole> roles) {
    if (_currentUser == null) return false;
    return roles.contains(_currentUser!.role);
  }
}
```

---

## 🔒 Guards Personalizados para Roles

### 1. RoleGuard - Guard Base para Roles

```dart
// lib/core/routes/guards/role_guard.dart
import 'package:auto_route/auto_route.dart';
import 'package:partners/core/models/user_role.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/main.dart';

/// Guard base para verificar roles de usuario
abstract class RoleGuard extends AutoRouteGuard {
  final RoleService _roleService;

  RoleGuard() : _roleService = getIt<RoleService>();

  /// Roles permitidos para esta ruta
  List<UserRole> get allowedRoles;

  /// Ruta de redirección cuando el usuario no tiene el rol necesario
  PageRouteInfo get redirectRoute => const LoginRoute();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final currentRole = _roleService.currentRole;

    if (currentRole == null) {
      // Usuario no autenticado
      resolver.redirectUntil(redirectRoute);
      return;
    }

    if (allowedRoles.contains(currentRole)) {
      resolver.next(true);
    } else {
      // Usuario no tiene el rol necesario
      resolver.redirectUntil(_getUnauthorizedRoute());
    }
  }

  /// Ruta a la que redirigir cuando no se tiene autorización
  PageRouteInfo _getUnauthorizedRoute() {
    // Puedes crear una ruta específica para "No autorizado"
    // Por ahora redirigimos al dashboard o login
    return const DashboardRoute();
  }
}
```

### 2. PermissionGuard - Guard para Permisos Específicos

```dart
// lib/core/routes/guards/permission_guard.dart
import 'package:auto_route/auto_route.dart';
import 'package:partners/core/models/permission.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/main.dart';

/// Guard para verificar permisos específicos
class PermissionGuard extends AutoRouteGuard {
  final RoleService _roleService;
  final List<Permission> _requiredPermissions;
  final bool requireAll; // Si true, requiere todos los permisos; si false, solo uno

  PermissionGuard({
    required List<Permission> requiredPermissions,
    this.requireAll = true,
  })  : _roleService = getIt<RoleService>(),
        _requiredPermissions = requiredPermissions;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final hasAccess = requireAll
        ? _roleService.hasAllPermissions(_requiredPermissions)
        : _roleService.hasAnyPermission(_requiredPermissions);

    if (hasAccess) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(const DashboardRoute());
    }
  }
}
```

### 3. Guards Específicos por Rol

```dart
// lib/core/routes/guards/admin_guard.dart
import 'package:partners/core/models/user_role.dart';
import 'package:partners/core/routes/guards/role_guard.dart';
import 'package:partners/core/routes/app_routes.gr.dart';

/// Guard para rutas que solo pueden acceder administradores
class AdminGuard extends RoleGuard {
  @override
  List<UserRole> get allowedRoles => [UserRole.admin];

  @override
  PageRouteInfo get redirectRoute => const DashboardRoute();
}
```

```dart
// lib/core/routes/guards/partner_guard.dart
import 'package:partners/core/models/user_role.dart';
import 'package:partners/core/routes/guards/role_guard.dart';
import 'package:partners/core/routes/app_routes.gr.dart';

/// Guard para rutas que pueden acceder partners y admins
class PartnerGuard extends RoleGuard {
  @override
  List<UserRole> get allowedRoles => [UserRole.partner, UserRole.admin];

  @override
  PageRouteInfo get redirectRoute => const DashboardRoute();
}
```

---

## 📱 Gestión de Roles en la Aplicación

### 1. Inicialización del RoleService

```dart
// lib/core/injection/role_injection.dart
import 'package:get_it/get_it.dart';
import 'package:partners/core/services/role_service.dart';

class RoleInjection {
  final GetIt _getIt;

  RoleInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    if (!_getIt.isRegistered<RoleService>()) {
      _getIt.registerLazySingleton<RoleService>(() => RoleService());
    }
  }
}
```

### 2. Actualizar AuthManager para Incluir Rol

```dart
// Ejemplo de cómo actualizar tu AuthManager existente
// lib/core/managers/auth/auth_manager.dart (extensión)

import 'package:partners/core/models/user_model.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/main.dart';

extension AuthManagerRoleExtension on AuthManager {
  Future<void> setUserWithRole(UserModel user) async {
    // Guardar usuario en AuthManager
    // ...
    
    // Actualizar RoleService
    final roleService = getIt<RoleService>();
    roleService.setUser(user);
  }

  Future<void> clearUserAndRole() async {
    // Limpiar usuario en AuthManager
    // ...
    
    // Limpiar RoleService
    final roleService = getIt<RoleService>();
    roleService.clearUser();
  }
}
```

### 3. Obtener Rol del Usuario desde el Token/API

```dart
// lib/core/services/user_service.dart
import 'package:partners/core/models/user_model.dart';
import 'package:partners/core/models/user_role.dart';

class UserService {
  /// Obtener información del usuario desde el token o API
  Future<UserModel> getCurrentUser() async {
    // Ejemplo: Obtener del token decodificado
    // final token = await tokenManager.getAccessToken();
    // final decodedToken = decodeToken(token);
    // final roleString = decodedToken['role'] as String;
    
    // Convertir string a enum
    // final role = UserRole.values.firstWhere(
    //   (r) => r.name == roleString,
    //   orElse: () => UserRole.guest,
    // );
    
    // return UserModel(
    //   id: decodedToken['id'],
    //   email: decodedToken['email'],
    //   name: decodedToken['name'],
    //   role: role,
    // );
    
    // Por ahora, ejemplo hardcodeado
    return UserModel(
      id: '1',
      email: 'user@example.com',
      name: 'Usuario',
      role: UserRole.partner,
    );
  }
}
```

---

## 💡 Ejemplos Prácticos

### 1. Configurar Rutas con Guards de Rol

```dart
// lib/core/routes/private_routes.dart
import 'package:auto_route/auto_route.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/routes/guards/auth_guard.dart';
import 'package:partners/core/routes/guards/admin_guard.dart';
import 'package:partners/core/routes/guards/partner_guard.dart';
import 'package:partners/core/routes/guards/permission_guard.dart';
import 'package:partners/core/models/permission.dart';

class PrivateRoutes {
  static List<AutoRoute> routes() => [
    AutoRoute(
      path: '/dashboard',
      guards: [AuthGuard()],
      page: DashboardRoute.page,
      children: [
        // Ruta solo para admins
        AutoRoute(
          path: '/admin',
          guards: [AdminGuard()],
          page: AdminRoute.page,
        ),
        
        // Ruta para partners y admins
        AutoRoute(
          path: '/partner',
          guards: [PartnerGuard()],
          page: PartnerRoute.page,
        ),
        
        // Ruta con permisos específicos
        AutoRoute(
          path: '/products',
          guards: [
            PermissionGuard(
              requiredPermissions: [Permission.readProducts],
            ),
          ],
          page: ProductsRoute.page,
        ),
        
        // Ruta que requiere múltiples permisos
        AutoRoute(
          path: '/products/create',
          guards: [
            PermissionGuard(
              requiredPermissions: [
                Permission.readProducts,
                Permission.createProducts,
              ],
              requireAll: true,
            ),
          ],
          page: CreateProductRoute.page,
        ),
      ],
    ),
  ];
}
```

### 2. Verificar Permisos en Widgets

```dart
// lib/features/products/presentation/widgets/product_actions.dart
import 'package:flutter/material.dart';
import 'package:partners/core/models/permission.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/main.dart';

class ProductActions extends StatelessWidget {
  final String productId;

  const ProductActions({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    final roleService = getIt<RoleService>();

    return Row(
      children: [
        // Botón de editar - solo si tiene permiso
        if (roleService.hasPermission(Permission.updateProducts))
          ElevatedButton(
            onPressed: () => _editProduct(context),
            child: const Text('Editar'),
          ),
        
        // Botón de eliminar - solo si tiene permiso
        if (roleService.hasPermission(Permission.deleteProducts))
          ElevatedButton(
            onPressed: () => _deleteProduct(context),
            child: const Text('Eliminar'),
          ),
      ],
    );
  }

  void _editProduct(BuildContext context) {
    // Navegar a edición
  }

  void _deleteProduct(BuildContext context) {
    // Eliminar producto
  }
}
```

### 3. Ocultar/Mostrar Elementos UI según Rol

```dart
// lib/core/widgets/role_based_widget.dart
import 'package:flutter/material.dart';
import 'package:partners/core/models/user_role.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/main.dart';

/// Widget que solo muestra su contenido si el usuario tiene el rol requerido
class RoleBasedWidget extends StatelessWidget {
  final List<UserRole> allowedRoles;
  final Widget child;
  final Widget? fallback;

  const RoleBasedWidget({
    required this.allowedRoles,
    required this.child,
    this.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final roleService = getIt<RoleService>();
    final currentRole = roleService.currentRole;

    if (currentRole != null && allowedRoles.contains(currentRole)) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}

// Uso:
// RoleBasedWidget(
//   allowedRoles: [UserRole.admin, UserRole.partner],
//   child: AdminPanel(),
// )
```

### 4. Verificar Permisos en Lógica de Negocio

```dart
// lib/features/products/domain/use_case/delete_product_usecase.dart
import 'package:partners/core/models/permission.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/main.dart';

class DeleteProductUsecase {
  final RoleService _roleService;

  DeleteProductUsecase() : _roleService = getIt<RoleService>();

  Future<void> execute(String productId) async {
    // Verificar permiso antes de ejecutar
    if (!_roleService.hasPermission(Permission.deleteProducts)) {
      throw const AuthenticationException(
        'No tienes permiso para eliminar productos',
        code: 403,
      );
    }

    // Lógica de eliminación
    // ...
  }
}
```

---

## ✅ Mejores Prácticas

### 1. **Definir Roles y Permisos Claramente**

- ✅ Usa enums para roles y permisos (type-safe)
- ✅ Documenta qué hace cada rol
- ✅ Mantén una lista centralizada de permisos

### 2. **Validación en Múltiples Capas**

- ✅ **UI Layer**: Ocultar/mostrar elementos según permisos
- ✅ **Route Layer**: Guards para proteger rutas
- ✅ **Business Logic Layer**: Verificar permisos antes de ejecutar acciones
- ✅ **API Layer**: El backend también debe validar permisos

### 3. **Manejo de Errores**

```dart
// lib/core/utils/exeptions/authorization_exception.dart
class AuthorizationException extends AppException {
  const AuthorizationException(
    super.message, {
    super.code = 403,
    super.details,
  });
}
```

### 4. **Testing de Roles y Permisos**

```dart
// test/core/services/role_service_test.dart
void main() {
  group('RoleService', () {
    test('debe retornar true cuando el usuario tiene el permiso', () {
      final roleService = RoleService();
      final user = UserModel(
        id: '1',
        email: 'admin@test.com',
        name: 'Admin',
        role: UserRole.admin,
      );
      
      roleService.setUser(user);
      
      expect(
        roleService.hasPermission(Permission.deleteProducts),
        isTrue,
      );
    });
  });
}
```

### 5. **Actualización de Roles en Tiempo Real**

```dart
// Si el rol del usuario cambia, actualizar el RoleService
class RoleService {
  final _roleController = StreamController<UserModel?>.broadcast();
  
  Stream<UserModel?> get roleStream => _roleController.stream;
  
  void setUser(UserModel user) {
    _currentUser = user;
    _roleController.add(user);
  }
}
```

### 6. **Logging y Auditoría**

```dart
// Registrar intentos de acceso no autorizados
class RoleGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    // ...
    if (!allowedRoles.contains(currentRole)) {
      // Log del intento de acceso no autorizado
      AppLogger.warning(
        'Intento de acceso no autorizado',
        'Usuario: ${_roleService.currentUser?.email}, '
        'Rol: ${currentRole}, '
        'Ruta requerida: ${allowedRoles.join(", ")}',
      );
      resolver.redirectUntil(_getUnauthorizedRoute());
    }
  }
}
```

---

## 🔄 Migración desde tu Sistema Actual

### Pasos para Integrar RBAC

1. **Crear modelos de roles y permisos** (enums)
2. **Crear RoleService** y registrarlo en GetIt
3. **Actualizar AuthManager** para establecer el rol del usuario al hacer login
4. **Crear guards de roles** (RoleGuard, PermissionGuard, etc.)
5. **Aplicar guards a rutas** existentes según necesidad
6. **Actualizar widgets** para verificar permisos antes de mostrar acciones
7. **Agregar validaciones** en casos de uso/negocio

---

## 📚 Recursos Adicionales

- [AutoRoute Documentation](https://autoroute.vercel.app/)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)
- [RBAC Patterns](https://en.wikipedia.org/wiki/Role-based_access_control)

---

## 📝 Notas Finales

- Esta guía está adaptada del artículo de Medium sobre RBAC con GoRouter, pero implementada para **AutoRoute**
- Los guards de AutoRoute funcionan de manera similar a los redirects de GoRouter
- Asegúrate de que el backend también valide roles y permisos
- Considera usar un sistema de permisos más granular si necesitas control fino sobre recursos específicos

---

**Última actualización:** Basado en el artículo de Medium sobre RBAC en Flutter
**Adaptado para:** AutoRoute en lugar de GoRouter
