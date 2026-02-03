class PasswordValidationRes {
  final String accessToken;
  final String refreshToken;

  PasswordValidationRes({
    required this.accessToken,
    required this.refreshToken,
  });

  PasswordValidationRes copyWith({
    String? accessToken,
    String? refreshToken,
  }) =>
      PasswordValidationRes(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  factory PasswordValidationRes.fromJson(Map<String, dynamic> json) =>
      PasswordValidationRes(
        accessToken: json["access_token"] ?? json["accessToken"] ?? '',
        refreshToken: json["refresh_token"] ?? json["refreshToken"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
