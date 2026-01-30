// lib/core/services/database/sqlite/entities/session_validation_entity.dart

/// Entidad que representa las validaciones de una sesión
/// Relación 1 a 1 con SessionEntity
/// Para RUC10 y RUC15: email, whatsapp, identity, password
/// Para RUC20: email, whatsapp, business, identity, password
class SessionValidationEntity {
  final int? id;
  final String sessionId; // Foreign key a sessions
  final bool email;
  final bool whatsapp;
  final bool? business; // Solo para RUC20, null para RUC10 y RUC15
  final bool identity;
  final bool password;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SessionValidationEntity({
    this.id,
    required this.sessionId,
    required this.email,
    required this.whatsapp,
    this.business,
    required this.identity,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea una copia de la entidad con campos opcionales actualizados
  SessionValidationEntity copyWith({
    int? id,
    String? sessionId,
    bool? email,
    bool? whatsapp,
    bool? business,
    bool? identity,
    bool? password,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionValidationEntity(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      business: business ?? this.business,
      identity: identity ?? this.identity,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convierte la entidad a un Map para guardar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'email': email ? 1 : 0, // SQLite usa INTEGER para booleanos
      'whatsapp': whatsapp ? 1 : 0,
      'business': business != null ? (business! ? 1 : 0) : null,
      'identity': identity ? 1 : 0,
      'password': password ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Crea una entidad desde un Map de la base de datos
  factory SessionValidationEntity.fromMap(Map<String, dynamic> map) {
    return SessionValidationEntity(
      id: map['id'] as int?,
      sessionId: map['session_id'] as String,
      email: (map['email'] as int) == 1,
      whatsapp: (map['whatsapp'] as int) == 1,
      business: map['business'] != null ? ((map['business'] as int) == 1) : null,
      identity: (map['identity'] as int) == 1,
      password: (map['password'] as int) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updated_at'] as int,
      ),
    );
  }

  /// Crea una entidad inicial con todos los valores en false
  factory SessionValidationEntity.initial(String sessionId) {
    final now = DateTime.now();
    return SessionValidationEntity(
      sessionId: sessionId,
      email: false,
      whatsapp: false,
      business: null, // Inicialmente null
      identity: false,
      password: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Verifica si todas las validaciones están completas (según el tipo de RUC)
  bool areAllValidationsComplete(bool isRuc20) {
    if (isRuc20) {
      return email && whatsapp && (business ?? false) && identity && password;
    } else {
      return email && whatsapp && identity && password;
    }
  }

  @override
  String toString() {
    return 'SessionValidationEntity(id: $id, sessionId: $sessionId, '
        'email: $email, whatsapp: $whatsapp, business: $business, '
        'identity: $identity, password: $password, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionValidationEntity &&
        other.id == id &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode => id.hashCode ^ sessionId.hashCode;
}
