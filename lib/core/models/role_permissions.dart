import 'package:partners/core/models/permission.dart';
import 'package:partners/core/models/user_role.dart';

/// Reglas de negocio por rol:
///
/// - **Dueño del negocio**: puede hacer todo (acceso completo).
/// - **Administrador**: maneja solo su sucursal (no crea/elimina sucursales).
/// - **Mesero/Cajera**: puede emitir puntos y operar pedidos en su ámbito.
///
/// Clase que mapea roles a sus permisos correspondientes.
/// Sigue el principio de Single Responsibility (SOLID).
class RolePermissions {
  /// Mapa estático que define los permisos para cada rol
  static const Map<UserRole, List<Permission>> rolePermissions = {
    // Superadministrador - acceso total (igual que dueño)
    UserRole.superadmin: [
      Permission.fullAccess,
      Permission.readProducts,
      Permission.createProducts,
      Permission.updateProducts,
      Permission.deleteProducts,
      Permission.readOrders,
      Permission.createOrders,
      Permission.updateOrders,
      Permission.cancelOrders,
      Permission.readPoints,
      Permission.emitPoints,
      Permission.redeemPoints,
      Permission.managePoints,
      Permission.readUsers,
      Permission.createUsers,
      Permission.updateUsers,
      Permission.deleteUsers,
      Permission.readBranches,
      Permission.createBranches,
      Permission.updateBranches,
      Permission.deleteBranches,
      Permission.manageBranch,
      Permission.readSettings,
      Permission.updateSettings,
      Permission.readReports,
      Permission.generateReports,
    ],

    // Dueño del negocio - puede hacer todo
    UserRole.businessOwner: [
      Permission.fullAccess,
      // Todos los permisos explícitos también
      Permission.readProducts,
      Permission.createProducts,
      Permission.updateProducts,
      Permission.deleteProducts,
      Permission.readOrders,
      Permission.createOrders,
      Permission.updateOrders,
      Permission.cancelOrders,
      Permission.readPoints,
      Permission.emitPoints,
      Permission.redeemPoints,
      Permission.managePoints,
      Permission.readUsers,
      Permission.createUsers,
      Permission.updateUsers,
      Permission.deleteUsers,
      Permission.readBranches,
      Permission.createBranches,
      Permission.updateBranches,
      Permission.deleteBranches,
      Permission.manageBranch,
      Permission.readSettings,
      Permission.updateSettings,
      Permission.readReports,
      Permission.generateReports,
    ],

    // Administrador - maneja solo su sucursal (no create/update/delete branches)
    UserRole.administrator: [
      // Productos - puede leer y actualizar
      Permission.readProducts,
      Permission.updateProducts,
      // Pedidos - puede gestionar pedidos de su sucursal
      Permission.readOrders,
      Permission.createOrders,
      Permission.updateOrders,
      Permission.cancelOrders,
      // Puntos - puede emitir y gestionar puntos
      Permission.readPoints,
      Permission.emitPoints,
      Permission.redeemPoints,
      Permission.managePoints,
      // Usuarios - puede leer y actualizar usuarios de su sucursal
      Permission.readUsers,
      Permission.updateUsers,
      // Sucursales - puede gestionar solo su sucursal
      Permission.readBranches,
      Permission.manageBranch,
      // Configuración - lectura
      Permission.readSettings,
      // Reportes - puede leer y generar reportes de su sucursal
      Permission.readReports,
      Permission.generateReports,
    ],

    // Mesero/Cajera - puede emitir puntos y operar pedidos
    UserRole.waiterCashier: [
      Permission.readProducts,
      Permission.readOrders,
      Permission.createOrders,
      Permission.updateOrders,
      Permission.readPoints,
      Permission.emitPoints,
      Permission.redeemPoints,
      Permission.readUsers,
    ],
  };

  /// Obtiene la lista de permisos para un rol específico
  ///
  /// [role] El rol del usuario
  /// Retorna la lista de permisos asociados al rol
  static List<Permission> getPermissionsForRole(UserRole role) {
    return rolePermissions[role] ?? [];
  }

  /// Verifica si un rol tiene un permiso específico
  ///
  /// [role] El rol del usuario
  /// [permission] El permiso a verificar
  /// Retorna true si el rol tiene el permiso, false en caso contrario
  static bool hasPermission(UserRole role, Permission permission) {
    final permissions = getPermissionsForRole(role);

    // Si tiene fullAccess, tiene todos los permisos
    if (permissions.contains(Permission.fullAccess)) {
      return true;
    }

    return permissions.contains(permission);
  }

  /// Verifica si un rol tiene alguno de los permisos especificados
  ///
  /// [role] El rol del usuario
  /// [permissions] Lista de permisos a verificar
  /// Retorna true si el rol tiene al menos uno de los permisos
  static bool hasAnyPermission(UserRole role, List<Permission> permissions) {
    return permissions.any((permission) => hasPermission(role, permission));
  }

  /// Verifica si un rol tiene todos los permisos especificados
  ///
  /// [role] El rol del usuario
  /// [permissions] Lista de permisos a verificar
  /// Retorna true si el rol tiene todos los permisos
  static bool hasAllPermissions(UserRole role, List<Permission> permissions) {
    return permissions.every((permission) => hasPermission(role, permission));
  }
}
