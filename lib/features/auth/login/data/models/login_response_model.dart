import 'package:partners/core/models/user_model.dart';
import 'package:partners/core/models/user_role.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  const LoginResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
  });

  /// Parsea la respuesta del backend.
  /// Acepta formato nuevo: { access_token, refresh_token, role: ["superadmin"] }
  /// o formato legacy: { accessToken, refreshToken, user: { ... } }.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'] as String? ?? json['accessToken'] as String? ?? '';
    final refreshToken = json['refresh_token'] as String? ?? json['refreshToken'] as String? ?? '';

    final UserModel user;
    if (json['user'] != null && json['user'] is Map<String, dynamic>) {
      user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    } else {
      final roleList = json['role'] as List<dynamic>?;
      final roleString = (roleList != null && roleList.isNotEmpty)
          ? (roleList.first as String?)
          : null;
      final role = roleString != null
          ? UserRoleExtension.fromString(roleString)
          : UserRole.waiterCashier;
      user = UserModel(
        id: '',
        email: '',
        name: '',
        role: role,
      );
    }

    return LoginResponseModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }
}
