class EmailValidationReq {
  final String sessionId;
  final String email;

  EmailValidationReq({required this.sessionId, required this.email});

  EmailValidationReq copyWith({String? sessionId, String? email}) =>
      EmailValidationReq(
        sessionId: sessionId ?? this.sessionId,
        email: email ?? this.email,
      );

  factory EmailValidationReq.fromJson(Map<String, dynamic> json) =>
      EmailValidationReq(sessionId: json["session_id"], email: json["email"]);

  Map<String, dynamic> toJson() => {"session_id": sessionId, "email": email};
}
