import 'package:partners/core/models/permission.dart';
import 'package:partners/core/models/role_permissions.dart';
import 'package:partners/core/models/user_role.dart';

/// Modelo que representa un usuario en el sistema
/// Incluye información del usuario y su rol
class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? branchId; // ID de la sucursal (para administradores)
  final List<Permission>? customPermissions; // Permisos personalizados opcionales

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.branchId,
    this.customPermissions,
  });

  /// Verifica si el usuario tiene un permiso específico
  /// 
  /// Primero verifica los permisos del rol, luego los permisos personalizados
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

  /// Verifica si el usuario tiene alguno de los permisos especificados
  bool hasAnyPermission(List<Permission> permissions) {
    return permissions.any((permission) => hasPermission(permission));
  }

  /// Verifica si el usuario tiene todos los permisos especificados
  bool hasAllPermissions(List<Permission> permissions) {
    return permissions.every((permission) => hasPermission(permission));
  }

  /// Verifica si el usuario tiene un rol específico
  bool hasRole(UserRole role) {
    return this.role == role;
  }

  /// Verifica si el usuario tiene alguno de los roles especificados
  bool hasAnyRole(List<UserRole> roles) {
    return roles.contains(role);
  }

  /// Crea una copia del modelo con campos actualizados
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? branchId,
    List<Permission>? customPermissions,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      branchId: branchId ?? this.branchId,
      customPermissions: customPermissions ?? this.customPermissions,
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.value,
      'branchId': branchId,
      'customPermissions': customPermissions?.map((p) => p.value).toList(),
    };
  }

  /// Crea un modelo desde un mapa JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRoleExtension.fromString(json['role'] as String),
      branchId: json['branchId'] as String?,
      customPermissions: json['customPermissions'] != null
          ? (json['customPermissions'] as List)
              .map((p) => PermissionExtension.fromString(p as String))
              .toList()
          : null,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, role: ${role.displayName}, branchId: $branchId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.role == role &&
        other.branchId == branchId;
  }

  @override
  int get hashCode {
    return Object.hash(id, email, name, role, branchId);
  }
}
