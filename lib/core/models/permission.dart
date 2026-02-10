/// Enum que representa los permisos específicos en el sistema
enum Permission {
  // Gestión de Productos
  readProducts,
  createProducts,
  updateProducts,
  deleteProducts,
  
  // Gestión de Pedidos/Órdenes
  readOrders,
  createOrders,
  updateOrders,
  cancelOrders,
  
  // Gestión de Puntos
  readPoints,
  emitPoints,
  redeemPoints,
  managePoints,
  
  // Gestión de Usuarios
  readUsers,
  createUsers,
  updateUsers,
  deleteUsers,
  
  // Gestión de Sucursales
  readBranches,
  createBranches,
  updateBranches,
  deleteBranches,
  manageBranch, // Gestionar solo su sucursal (para administradores)
  
  // Configuración y Reportes
  readSettings,
  updateSettings,
  readReports,
  generateReports,
  
  // Acceso completo (solo para dueño del negocio)
  fullAccess,
}

/// Extensión para convertir Permission a String y viceversa
extension PermissionExtension on Permission {
  /// Convierte el enum a string (para APIs, storage, etc.)
  String get value {
    switch (this) {
      case Permission.readProducts:
        return 'read:products';
      case Permission.createProducts:
        return 'create:products';
      case Permission.updateProducts:
        return 'update:products';
      case Permission.deleteProducts:
        return 'delete:products';
      case Permission.readOrders:
        return 'read:orders';
      case Permission.createOrders:
        return 'create:orders';
      case Permission.updateOrders:
        return 'update:orders';
      case Permission.cancelOrders:
        return 'cancel:orders';
      case Permission.readPoints:
        return 'read:points';
      case Permission.emitPoints:
        return 'emit:points';
      case Permission.redeemPoints:
        return 'redeem:points';
      case Permission.managePoints:
        return 'manage:points';
      case Permission.readUsers:
        return 'read:users';
      case Permission.createUsers:
        return 'create:users';
      case Permission.updateUsers:
        return 'update:users';
      case Permission.deleteUsers:
        return 'delete:users';
      case Permission.readBranches:
        return 'read:branches';
      case Permission.createBranches:
        return 'create:branches';
      case Permission.updateBranches:
        return 'update:branches';
      case Permission.deleteBranches:
        return 'delete:branches';
      case Permission.manageBranch:
        return 'manage:branch';
      case Permission.readSettings:
        return 'read:settings';
      case Permission.updateSettings:
        return 'update:settings';
      case Permission.readReports:
        return 'read:reports';
      case Permission.generateReports:
        return 'generate:reports';
      case Permission.fullAccess:
        return 'full:access';
    }
  }

  /// Convierte string a enum
  static Permission fromString(String value) {
    switch (value.toLowerCase()) {
      case 'read:products':
        return Permission.readProducts;
      case 'create:products':
        return Permission.createProducts;
      case 'update:products':
        return Permission.updateProducts;
      case 'delete:products':
        return Permission.deleteProducts;
      case 'read:orders':
        return Permission.readOrders;
      case 'create:orders':
        return Permission.createOrders;
      case 'update:orders':
        return Permission.updateOrders;
      case 'cancel:orders':
        return Permission.cancelOrders;
      case 'read:points':
        return Permission.readPoints;
      case 'emit:points':
        return Permission.emitPoints;
      case 'redeem:points':
        return Permission.redeemPoints;
      case 'manage:points':
        return Permission.managePoints;
      case 'read:users':
        return Permission.readUsers;
      case 'create:users':
        return Permission.createUsers;
      case 'update:users':
        return Permission.updateUsers;
      case 'delete:users':
        return Permission.deleteUsers;
      case 'read:branches':
        return Permission.readBranches;
      case 'create:branches':
        return Permission.createBranches;
      case 'update:branches':
        return Permission.updateBranches;
      case 'delete:branches':
        return Permission.deleteBranches;
      case 'manage:branch':
        return Permission.manageBranch;
      case 'read:settings':
        return Permission.readSettings;
      case 'update:settings':
        return Permission.updateSettings;
      case 'read:reports':
        return Permission.readReports;
      case 'generate:reports':
        return Permission.generateReports;
      case 'full:access':
        return Permission.fullAccess;
      default:
        throw ArgumentError('Invalid Permission value: $value');
    }
  }
}
