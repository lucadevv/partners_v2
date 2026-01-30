// lib/core/services/database/session_id_flug.dart
import 'package:partners/core/services/database/flags/flags.dart';
import 'package:partners/core/utils/conts/prefers_keys.dart';

class SessionIdFlug extends BaseFlags {
  // Usamos la misma instancia de SharedPreferences que todos

  // =============== MÉTODOS ESPECÍFICOS ===============

  Future<void> saveSessionId(String sessionId) async {
    await saveFlag(PrefersKeys.sessionId, sessionId);
  }

  String? get sessionId => getFlagAs<String>(PrefersKeys.sessionId);

  bool get hasSessionId => containsFlag(PrefersKeys.sessionId);

  Future<void> clearSessionId() async {
    await removeFlag(PrefersKeys.sessionId);
  }

  bool get isValidSessionId {
    final id = sessionId;
    return id != null && id.isNotEmpty;
  }

  // =============== MÉTODOS ADICIONALES ===============

  Future<void> saveSessionWithExpiry(
    String sessionId,
    Duration expiresIn,
  ) async {
    await saveSessionId(sessionId);
    final expiryTime = DateTime.now().add(expiresIn);
    await saveFlag(
      '${PrefersKeys.sessionId}_expiry',
      expiryTime.toIso8601String(),
    );
  }

  bool get isSessionExpired {
    final expiryString = getFlagAs<String>('${PrefersKeys.sessionId}_expiry');
    if (expiryString == null) return false;

    final expiryTime = DateTime.tryParse(expiryString);
    if (expiryTime == null) return false;

    return DateTime.now().isAfter(expiryTime);
  }

  bool get shouldRefreshSession {
    return hasSessionId && !isSessionExpired;
  }
}
