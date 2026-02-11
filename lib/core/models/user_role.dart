/// Enum que representa los roles de usuario en el sistema
enum UserRole {
  /// Superadministrador - Acceso total
  superadmin,

  /// Dueño del negocio - Puede hacer todo
  businessOwner,

  /// Administrador - Maneja solo su sucursal
  administrator,

  /// Mesero/Cajera - Puede emitir puntos y tiene permisos limitados
  waiterCashier,
}

/// Extensión para convertir UserRole a String y viceversa
extension UserRoleExtension on UserRole {
  /// Convierte el enum a string (para APIs, storage, etc.)
  String get value {
    switch (this) {
      case UserRole.superadmin:
        return 'superadmin';
      case UserRole.businessOwner:
        return 'business_owner';
      case UserRole.administrator:
        return 'administrator';
      case UserRole.waiterCashier:
        return 'waiter_cashier';
    }
  }

  /// Convierte string a enum
  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'superadmin':
      case 'super_admin':
        return UserRole.superadmin;
      case 'business_owner':
      case 'businessowner':
        return UserRole.businessOwner;
      case 'administrator':
      case 'admin':
        return UserRole.administrator;
      case 'waiter_cashier':
      case 'waitercashier':
      case 'waiter':
      case 'cashier':
        return UserRole.waiterCashier;
      default:
        throw ArgumentError('Invalid UserRole value: $value');
    }
  }

  /// Nombre legible del rol
  String get displayName {
    switch (this) {
      case UserRole.superadmin:
        return 'Superadministrador';
      case UserRole.businessOwner:
        return 'Dueño del Negocio';
      case UserRole.administrator:
        return 'Administrador';
      case UserRole.waiterCashier:
        return 'Mesero/Cajera';
    }
  }
}
