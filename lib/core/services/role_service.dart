import 'dart:async';
import 'package:partners/core/models/permission.dart';
import 'package:partners/core/models/user_model.dart';
import 'package:partners/core/models/user_role.dart';

/// Servicio para gestionar roles y permisos de usuarios
/// Sigue el principio de Single Responsibility (SOLID)
class RoleService {
  UserModel? _currentUser;
  final _userController = StreamController<UserModel?>.broadcast();

  /// Usuario actual autenticado
  UserModel? get currentUser => _currentUser;

  /// Stream de cambios en el usuario actual
  Stream<UserModel?> get userStream => _userController.stream;

  /// Rol del usuario actual
  UserRole? get currentRole => _currentUser?.role;

  /// Establece el usuario actual
  void setUser(UserModel user) {
    _currentUser = user;
    _userController.add(user);
  }

  /// Limpia el usuario actual (logout)
  void clearUser() {
    _currentUser = null;
    _userController.add(null);
  }

  /// Verifica si el usuario actual tiene un permiso específico
  bool hasPermission(Permission permission) {
    if (_currentUser == null) return false;
    return _currentUser!.hasPermission(permission);
  }

  /// Verifica si el usuario actual tiene alguno de los permisos especificados
  bool hasAnyPermission(List<Permission> permissions) {
    if (_currentUser == null) return false;
    return _currentUser!.hasAnyPermission(permissions);
  }

  /// Verifica si el usuario actual tiene todos los permisos especificados
  bool hasAllPermissions(List<Permission> permissions) {
    if (_currentUser == null) return false;
    return _currentUser!.hasAllPermissions(permissions);
  }

  /// Verifica si el usuario actual tiene un rol específico
  bool hasRole(UserRole role) {
    return _currentUser?.role == role;
  }

  /// Verifica si el usuario actual tiene alguno de los roles especificados
  bool hasAnyRole(List<UserRole> roles) {
    if (_currentUser == null) return false;
    return _currentUser!.hasAnyRole(roles);
  }

  /// Verifica si el usuario está autenticado
  bool get isAuthenticated => _currentUser != null;

  /// Obtiene el ID de la sucursal del usuario (si aplica)
  String? get branchId => _currentUser?.branchId;

  /// Libera recursos
  void dispose() {
    _userController.close();
  }
}
