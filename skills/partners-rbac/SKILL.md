---
name: partners-rbac
description: >
  Role-Based Access Control patterns for Partners app - permissions, roles, access validation.
  Trigger: Implementing RBAC logic, permission checks, role management.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [rbac]
  auto_invoke:
    - "Implementing RBAC logic"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## RBAC Overview

Partners app implements comprehensive Role-Based Access Control (RBAC) for secure operations.

## Core Components

### Roles
Define user permissions and access levels within the system.

### Permissions
Granular actions that can be performed on resources.

### Resources
System entities that require protection (branches, transactions, users, etc.).

## Domain Entities

### Role Entity
```dart
class Role extends Entity {
  final String name;
  final String description;
  final List<Permission> permissions;
  final RoleLevel level;
  final bool isSystem;
  final Role? parentRole;
  final Map<String, dynamic>? metadata;
  
  const Role({
    required String id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.level,
    this.isSystem = false,
    this.parentRole,
    this.metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  // Business logic
  bool get isAdmin => level == RoleLevel.admin;
  bool get isManager => level == RoleLevel.manager;
  bool get isSupervisor => level == RoleLevel.supervisor;
  bool get isWorker => level == RoleLevel.worker;
  bool get isViewer => level == RoleLevel.viewer;
  
  bool get hasFullAccess => permissions.contains(Permission.all);
  bool get canManageUsers => permissions.contains(Permission.userCreate) && 
                              permissions.contains(Permission.userRead) && 
                              permissions.contains(Permission.userUpdate) && 
                              permissions.contains(Permission.userDelete);
  
  String get levelDisplay {
    switch (level) {
      case RoleLevel.admin:
        return 'Administrador';
      case RoleLevel.manager:
        return 'Gerente';
      case RoleLevel.supervisor:
        return 'Supervisor';
      case RoleLevel.worker:
        return 'Trabajador';
      case RoleLevel.viewer:
        return 'Visualizador';
    }
  }
}
```

### Permission Entity
```dart
class Permission extends Entity {
  final String name;
  final String description;
  final String resource;
  final String action;
  final PermissionCategory category;
  final List<String> attributes;
  final bool isSystem;
  
  const Permission({
    required String id,
    required this.name,
    required this.description,
    required this.resource,
    required this.action,
    required this.category,
    this.attributes = const [],
    this.isSystem = false,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  // Business logic
  bool get isUserPermission => resource == 'user';
  bool get isBranchPermission => resource == 'branch';
  bool get isTransactionPermission => resource == 'transaction';
  bool get isReportPermission => resource == 'report';
  bool get isSystemPermission => isSystem;
  
  String get fullName => '$resource.$action';
  
  String get categoryDisplay {
    switch (category) {
      case PermissionCategory.user:
        return 'Gestión de Usuarios';
      case PermissionCategory.branch:
        return 'Gestión de Sucursales';
      case PermissionCategory.transaction:
        return 'Gestión de Transacciones';
      case PermissionCategory.report:
        return 'Reportes';
      case PermissionCategory.system:
        return 'Sistema';
    }
  }
}
```

### User Role Assignment
```dart
class UserRoleAssignment extends Entity {
  final String userId;
  final String roleId;
  final String? branchId;
  final DateTime assignedAt;
  final DateTime? expiresAt;
  final String? assignedBy;
  final bool isActive;
  final Map<String, dynamic>? metadata;
  
  const UserRoleAssignment({
    required String id,
    required this.userId,
    required this.roleId,
    this.branchId,
    required this.assignedAt,
    this.expiresAt,
    this.assignedBy,
    this.isActive = true,
    this.metadata,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: assignedAt, updatedAt: updatedAt);
  
  // Business logic
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get isValid => isActive && !isExpired;
  bool get isBranchSpecific => branchId != null && branchId!.isNotEmpty;
}
```

## Permission Definitions

### Permission Categories
```dart
enum PermissionCategory {
  user,      // User management
  branch,    // Branch management
  transaction, // Transaction management
  report,     // Report access
  system,     // System administration
}

enum Permission {
  // User permissions
  userCreate, userRead, userUpdate, userDelete, userAssignRoles,
  
  // Branch permissions
  branchCreate, branchRead, branchUpdate, branchDelete, branchActivate,
  
  // Transaction permissions
  transactionCreate, transactionRead, transactionUpdate, transactionDelete,
  transactionIssue, transactionRedeem, transactionReverse,
  
  // Report permissions
  reportRead, reportExport, reportSchedule,
  
  // System permissions
  systemConfig, systemLogs, systemBackup, systemRestore,
  
  // Special permission
  all,  // Full access
}
```

### Role Hierarchy
```dart
enum RoleLevel {
  viewer(1),     // Read-only access
  worker(2),    // Basic operational access
  supervisor(3), // Supervisory access
  manager(4),   // Management access
  admin(5),      // Full system access
}

class RoleHierarchy {
  static final Map<RoleLevel, List<Permission>> defaultPermissions = {
    RoleLevel.viewer: [
      Permission.userRead,
      Permission.branchRead,
      Permission.transactionRead,
      Permission.reportRead,
    ],
    
    RoleLevel.worker: [
      Permission.userRead,
      Permission.branchRead,
      Permission.transactionCreate,
      Permission.transactionRead,
      Permission.reportRead,
    ],
    
    RoleLevel.supervisor: [
      Permission.userRead,
      Permission.userUpdate,
      Permission.branchRead,
      Permission.branchUpdate,
      Permission.transactionCreate,
      Permission.transactionRead,
      Permission.transactionUpdate,
      Permission.reportRead,
    ],
    
    RoleLevel.manager: [
      Permission.userCreate,
      Permission.userRead,
      Permission.userUpdate,
      Permission.userDelete,
      Permission.userAssignRoles,
      Permission.branchCreate,
      Permission.branchRead,
      Permission.branchUpdate,
      Permission.branchDelete,
      Permission.branchActivate,
      Permission.transactionCreate,
      Permission.transactionRead,
      Permission.transactionUpdate,
      Permission.transactionDelete,
      Permission.transactionIssue,
      Permission.transactionReverse,
      Permission.reportRead,
      Permission.reportExport,
    ],
    
    RoleLevel.admin: [
      Permission.all,  // Full access
    ],
  };
}
```

## Use Cases

### Check Permission Use Case
```dart
class CheckPermissionUseCase implements UseCase<bool, CheckPermissionParams> {
  final RBACRepository _rbacRepository;
  final AuthManager _authManager;
  
  CheckPermissionUseCase(this._rbacRepository, this._authManager);
  
  @override
  Future<Either<RBACFailure, bool>> call(CheckPermissionParams params) async {
    // Get current user
    final currentUser = await _authManager.getCurrentUser();
    if (currentUser == null) {
      return Left(RBACFailure.authenticationRequired);
    }
    
    try {
      // Get user's active role assignments
      final roleAssignments = await _rbacRepository.getUserRoleAssignments(
        currentUser.id,
        branchId: params.branchId,
        onlyActive: true,
      );
      
      if (roleAssignments.isEmpty) {
        return const Right(false);
      }
      
      // Check permissions for each role
      for (final assignment in roleAssignments) {
        final role = await _rbacRepository.getRoleById(assignment.roleId);
        if (role == null) continue;
        
        // Check for full access
        if (role.permissions.contains(Permission.all)) {
          return const Right(true);
        }
        
        // Check specific permission
        if (role.permissions.contains(params.permission)) {
          // Check branch-specific permissions
          if (params.branchId != null && assignment.isBranchSpecific) {
            if (assignment.branchId == params.branchId) {
              return const Right(true);
            }
            continue; // Try next role
          } else {
            return const Right(true);
          }
        }
      }
      
      return const Right(false);
    } catch (e) {
      return Left(RBACFailure.custom('Permission check failed: $e'));
    }
  }
}
```

### Assign Role Use Case
```dart
class AssignRoleUseCase implements UseCase<UserRoleAssignment, AssignRoleParams> {
  final RBACRepository _rbacRepository;
  final AuthManager _authManager;
  
  AssignRoleUseCase(this._rbacRepository, this._authManager);
  
  @override
  Future<Either<RBACFailure, UserRoleAssignment>> call(AssignRoleParams params) async {
    // Check assigner permissions
    final assigner = await _authManager.getCurrentUser();
    if (assigner == null || !_canAssignRole(assigner.role, params.roleId)) {
      return Left(RBACFailure.insufficientPermissions);
    }
    
    // Validate assignment parameters
    final validationError = _validateAssignmentParams(params);
    if (validationError != null) {
      return Left(RBACFailure.invalidData(validationError));
    }
    
    try {
      // Check if user already has this role
      final existingAssignment = await _rbacRepository.getActiveRoleAssignment(
        params.userId,
        params.roleId,
        params.branchId,
      );
      
      UserRoleAssignment assignment;
      
      if (existingAssignment != null) {
        // Update existing assignment
        assignment = existingAssignment.copyWith(
          expiresAt: params.expiresAt,
          isActive: true,
          metadata: params.metadata,
          updatedAt: DateTime.now(),
        );
        
        await _rbacRepository.updateRoleAssignment(assignment);
      } else {
        // Create new assignment
        assignment = UserRoleAssignment(
          id: _generateAssignmentId(),
          userId: params.userId,
          roleId: params.roleId,
          branchId: params.branchId,
          assignedAt: DateTime.now(),
          expiresAt: params.expiresAt,
          assignedBy: assigner.id,
          isActive: true,
          metadata: params.metadata,
        );
        
        assignment = await _rbacRepository.createRoleAssignment(assignment);
      }
      
      return Right(assignment);
    } catch (e) {
      return Left(RBACFailure.custom('Role assignment failed: $e'));
    }
  }
  
  bool _canAssignRole(UserRole assignerRole, String roleId) async {
    // Admins can assign any role
    if (assignerRole == UserRole.admin) return true;
    
    // Get target role level
    final targetRole = await _rbacRepository.getRoleById(roleId);
    if (targetRole == null) return false;
    
    // Managers can assign up to supervisor
    if (assignerRole == UserRole.manager) {
      return targetRole.level.index <= RoleLevel.supervisor.index;
    }
    
    // Supervisors can assign up to worker
    if (assignerRole == UserRole.supervisor) {
      return targetRole.level.index <= RoleLevel.worker.index;
    }
    
    return false;
  }
  
  String? _validateAssignmentParams(AssignRoleParams params) {
    if (params.userId.isEmpty) return 'User ID is required';
    if (params.roleId.isEmpty) return 'Role ID is required';
    
    if (params.expiresAt != null && params.expiresAt!.isBefore(DateTime.now())) {
      return 'Expiration date cannot be in the past';
    }
    
    return null;
  }
}
```

### Create Custom Role Use Case
```dart
class CreateRoleUseCase implements UseCase<Role, CreateRoleParams> {
  final RBACRepository _rbacRepository;
  final AuthManager _authManager;
  
  CreateRoleUseCase(this._rbacRepository, this._authManager);
  
  @override
  Future<Either<RBACFailure, Role>> call(CreateRoleParams params) async {
    // Check creator permissions
    final creator = await _authManager.getCurrentUser();
    if (creator == null || !_canCreateRole(creator.role)) {
      return Left(RBACFailure.insufficientPermissions);
    }
    
    // Validate role parameters
    final validationError = _validateRoleParams(params);
    if (validationError != null) {
      return Left(RBACFailure.invalidData(validationError));
    }
    
    try {
      // Check if role name already exists
      final existingRole = await _rbacRepository.getRoleByName(params.name);
      if (existingRole != null) {
        return Left(RBACFailure.roleAlreadyExists);
      }
      
      // Create role
      final role = Role(
        id: _generateRoleId(),
        name: params.name,
        description: params.description,
        permissions: params.permissions,
        level: params.level,
        isSystem: false,
        metadata: params.metadata,
        createdAt: DateTime.now(),
      );
      
      final createdRole = await _rbacRepository.createRole(role);
      
      return Right(createdRole);
    } catch (e) {
      return Left(RBACFailure.custom('Role creation failed: $e'));
    }
  }
  
  bool _canCreateRole(UserRole creatorRole) {
    return creatorRole == UserRole.admin || creatorRole == UserRole.manager;
  }
  
  String? _validateRoleParams(CreateRoleParams params) {
    if (params.name.trim().isEmpty) return 'Role name is required';
    if (params.name.trim().length < 3) return 'Role name must be at least 3 characters';
    
    if (params.description.trim().isEmpty) return 'Role description is required';
    
    if (params.permissions.isEmpty) return 'Role must have at least one permission';
    
    // Validate permission hierarchy
    if (!_isValidPermissionCombination(params.level, params.permissions)) {
      return 'Invalid permission combination for this role level';
    }
    
    return null;
  }
  
  bool _isValidPermissionCombination(RoleLevel level, List<Permission> permissions) {
    // Get default permissions for this level
    final defaultPerms = RoleHierarchy.defaultPermissions[level] ?? [];
    
    // Custom roles cannot have more permissions than default for their level
    // unless they're admin
    if (level != RoleLevel.admin && permissions.length > defaultPerms.length) {
      return false;
    }
    
    // Check for restricted permissions
    final restrictedPerms = _getRestrictedPermissions(level);
    for (final perm in permissions) {
      if (restrictedPerms.contains(perm)) {
        return false;
      }
    }
    
    return true;
  }
  
  List<Permission> _getRestrictedPermissions(RoleLevel level) {
    switch (level) {
      case RoleLevel.viewer:
        return [
          Permission.userCreate, Permission.userUpdate, Permission.userDelete,
          Permission.branchCreate, Permission.branchUpdate, Permission.branchDelete,
          Permission.transactionDelete, Permission.transactionIssue, Permission.transactionReverse,
        ];
      case RoleLevel.worker:
        return [
          Permission.userCreate, Permission.userDelete, Permission.userAssignRoles,
          Permission.branchCreate, Permission.branchDelete, Permission.branchActivate,
          Permission.transactionDelete, Permission.transactionReverse,
        ];
      case RoleLevel.supervisor:
        return [
          Permission.userDelete, Permission.userAssignRoles,
          Permission.branchDelete, Permission.branchActivate,
          Permission.transactionDelete,
        ];
      case RoleLevel.manager:
        return [
          Permission.systemConfig, Permission.systemLogs, Permission.systemBackup,
        ];
      case RoleLevel.admin:
        return []; // Admins have no restrictions
    }
  }
}
```

## Repository Patterns

### RBAC Repository Interface
```dart
abstract class RBACRepository {
  // Role management
  Future<Either<RBACFailure, Role>> createRole(Role role);
  Future<Either<RBACFailure, List<Role>>> getRoles({bool? onlyActive});
  Future<Either<RBACFailure, Role?>> getRoleById(String id);
  Future<Either<RBACFailure, Role?>> getRoleByName(String name);
  Future<Either<RBACFailure, void>> updateRole(Role role);
  Future<Either<RBACFailure, void>> deleteRole(String id);
  
  // Permission management
  Future<Either<RBACFailure, List<Permission>>> getPermissions();
  Future<Either<RBACFailure, Permission?>> getPermissionById(String id);
  
  // Role assignment management
  Future<Either<RBACFailure, UserRoleAssignment>> createRoleAssignment(UserRoleAssignment assignment);
  Future<Either<RBACFailure, List<UserRoleAssignment>>> getUserRoleAssignments(
    String userId, {
    String? branchId,
    bool? onlyActive,
  });
  Future<Either<RBACFailure, UserRoleAssignment?>> getActiveRoleAssignment(
    String userId, String? roleId, String? branchId);
  Future<Either<RBACFailure, void>> updateRoleAssignment(UserRoleAssignment assignment);
  Future<Either<RBACFailure, void>> revokeRoleAssignment(String assignmentId);
  
  // Permission checking
  Future<Either<RBACFailure, bool>> userHasPermission(
    String userId, Permission permission, {String? branchId});
  Future<Either<RBACFailure, List<Permission>>> getUserPermissions(
    String userId, {String? branchId});
}
```

## Middleware Implementation

### RBAC Middleware
```dart
class RBACMiddleware {
  final RBACRepository _rbacRepository;
  final AuthManager _authManager;
  
  RBACMiddleware(this._rbacRepository, this._authManager);
  
  // Check if user can access resource
  Future<bool> canAccess(String resource, String action, {String? branchId}) async {
    final permission = _getPermissionFromResourceAction(resource, action);
    final result = await GetIt.instance<CheckPermissionUseCase>()(
      CheckPermissionParams(
        permission: permission,
        branchId: branchId,
      ),
    );
    
    return result.fold(
      (failure) => false,
      (hasPermission) => hasPermission,
    );
  }
  
  // Get user permissions for UI
  Future<List<Permission>> getUserPermissions({String? branchId}) async {
    final currentUser = await _authManager.getCurrentUser();
    if (currentUser == null) return [];
    
    final result = await _rbacRepository.getUserPermissions(
      currentUser.id,
      branchId: branchId,
    );
    
    return result.fold(
      (failure) => [],
      (permissions) => permissions,
    );
  }
  
  // Check if user has any of the specified permissions
  Future<bool> hasAnyPermission(List<Permission> permissions, {String? branchId}) async {
    for (final permission in permissions) {
      final canAccess = await this.canAccess(
        permission.resource,
        permission.action,
        branchId: branchId,
      );
      if (canAccess) return true;
    }
    return false;
  }
  
  // Check if user has all specified permissions
  Future<bool> hasAllPermissions(List<Permission> permissions, {String? branchId}) async {
    for (final permission in permissions) {
      final canAccess = await this.canAccess(
        permission.resource,
        permission.action,
        branchId: branchId,
      );
      if (!canAccess) return false;
    }
    return true;
  }
  
  Permission _getPermissionFromResourceAction(String resource, String action) {
    switch ('$resource.$action') {
      case 'user.create': return Permission.userCreate;
      case 'user.read': return Permission.userRead;
      case 'user.update': return Permission.userUpdate;
      case 'user.delete': return Permission.userDelete;
      case 'branch.create': return Permission.branchCreate;
      case 'branch.read': return Permission.branchRead;
      case 'branch.update': return Permission.branchUpdate;
      case 'branch.delete': return Permission.branchDelete;
      case 'transaction.create': return Permission.transactionCreate;
      case 'transaction.read': return Permission.transactionRead;
      case 'transaction.issue': return Permission.transactionIssue;
      case 'transaction.redeem': return Permission.transactionRedeem;
      case 'report.read': return Permission.reportRead;
      case 'report.export': return Permission.reportExport;
      default: return Permission.all; // Unknown permission
    }
  }
}
```

### Permission Widget
```dart
class PermissionWidget extends StatelessWidget {
  final Widget child;
  final Permission permission;
  final String? branchId;
  final Widget? fallback;
  
  const PermissionWidget({
    Key? key,
    required this.child,
    required this.permission,
    this.branchId,
    this.fallback,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: GetIt.instance<RBACMiddleware>().canAccess(
        permission.resource,
        permission.action,
        branchId: branchId,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return child;
        }
        
        // Show fallback or nothing
        return fallback ?? 
               Container(
                 decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: Center(
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Icon(
                         Icons.lock,
                         color: Theme.of(context).colorScheme.error,
                       ),
                       SizedBox(height: 8),
                       Text(
                         'Access Denied',
                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                           color: Theme.of(context).colorScheme.error,
                         ),
                       ),
                     ],
                   ),
                 ),
               );
      },
    );
  }
}
```

## Usage Examples

### Protecting Routes
```dart
class ProtectedRoute extends StatefulWidget {
  final Widget child;
  final List<Permission> requiredPermissions;
  final String? branchId;
  
  const ProtectedRoute({
    Key? key,
    required this.child,
    required this.requiredPermissions,
    this.branchId,
  }) : super(key: key);
  
  @override
  _ProtectedRouteState createState() => _ProtectedRouteState();
}

class _ProtectedRouteState extends State<ProtectedRoute> {
  bool _isChecking = true;
  bool _hasAccess = false;
  
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }
  
  Future<void> _checkPermissions() async {
    setState(() => _isChecking = true);
    
    final rbac = GetIt.instance<RBACMiddleware>();
    _hasAccess = await rbac.hasAllPermissions(widget.requiredPermissions, branchId: widget.branchId);
    
    setState(() => _isChecking = false);
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return LoadingWidget(message: 'Checking permissions...');
    }
    
    if (!_hasAccess) {
      return AccessDeniedWidget();
    }
    
    return widget.child;
  }
}
```

## Related Skills

- `partners` - Project overview and navigation
- `partners-auth` - Authentication and authorization
- `partners-domain` - RBAC domain entities and use cases
- `partners-data` - RBAC data sources and models
- `partners-ui` - RBAC UI patterns
- `partners-testing` - RBAC testing
- `state-management` - RBAC BLoC/Cubit patterns