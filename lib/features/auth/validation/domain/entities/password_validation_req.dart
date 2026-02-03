class PasswordValidationReq {
  final String sessionId;
  final String password;
  final String passwordConfirmation;

  PasswordValidationReq({
    required this.sessionId,
    required this.password,
    required this.passwordConfirmation,
  });

  PasswordValidationReq copyWith({
    String? sessionId,
    String? password,
    String? passwordConfirmation,
  }) =>
      PasswordValidationReq(
        sessionId: sessionId ?? this.sessionId,
        password: password ?? this.password,
        passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      );

  factory PasswordValidationReq.fromJson(Map<String, dynamic> json) =>
      PasswordValidationReq(
        sessionId: json["session_id"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
      );

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };
}
