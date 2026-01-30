// lib/core/services/database/sqlite/entities/session_entity.dart
import 'package:partners/core/utils/enums/enums.dart';

/// Entidad que representa una sesión en la base de datos
/// Sigue el principio de inmutabilidad
class SessionEntity {
  final int? id;
  final String sessionId;
  final RucType ruc;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SessionEntity({
    this.id,
    required this.sessionId,
    required this.ruc,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea una copia de la entidad con campos opcionales actualizados
  SessionEntity copyWith({
    int? id,
    String? sessionId,
    RucType? ruc,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionEntity(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      ruc: ruc ?? this.ruc,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convierte la entidad a un Map para guardar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'ruc': ruc.name, // Convierte enum a string
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Crea una entidad desde un Map de la base de datos
  factory SessionEntity.fromMap(Map<String, dynamic> map) {
    return SessionEntity(
      id: map['id'] as int?,
      sessionId: map['session_id'] as String,
      ruc: RucType.values.firstWhere(
        (e) => e.name == map['ruc'] as String,
        orElse: () => RucType.ruc10,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updated_at'] as int,
      ),
    );
  }

  @override
  String toString() {
    return 'SessionEntity(id: $id, sessionId: $sessionId, ruc: $ruc, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionEntity &&
        other.id == id &&
        other.sessionId == sessionId &&
        other.ruc == ruc;
  }

  @override
  int get hashCode => id.hashCode ^ sessionId.hashCode ^ ruc.hashCode;
}
