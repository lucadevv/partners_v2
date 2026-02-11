/// Respuesta del backend al completar contraseña (mismo formato que login).
/// Incluye access_token, refresh_token y role (array).
class PasswordValidationRes {
  final String accessToken;
  final String refreshToken;
  /// Rol del usuario (primer elemento de [role] del backend).
  final String? role;

  PasswordValidationRes({
    required this.accessToken,
    required this.refreshToken,
    this.role,
  });

  PasswordValidationRes copyWith({
    String? accessToken,
    String? refreshToken,
    String? role,
  }) =>
      PasswordValidationRes(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        role: role ?? this.role,
      );

  factory PasswordValidationRes.fromJson(Map<String, dynamic> json) {
    final roleList = json['role'] as List<dynamic>?;
    final roleString = (roleList != null && roleList.isNotEmpty)
        ? (roleList.first as String?)
        : null;
    return PasswordValidationRes(
      accessToken: json['access_token'] as String? ?? json['accessToken'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? json['refreshToken'] as String? ?? '',
      role: roleString,
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        if (role != null) 'role': [role],
      };
}
