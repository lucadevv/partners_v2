import 'package:partners/core/models/user_model.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  const LoginResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.isCompleteData,
    required super.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      isCompleteData: json['isCompleteData'] as bool? ?? false,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'isCompleteData': isCompleteData,
      'user': user.toJson(),
    };
  }

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      isCompleteData: isCompleteData,
      user: user,
    );
  }
}
