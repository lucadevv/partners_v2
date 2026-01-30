class OtpEmailReq {
  final String sessionId;
  final String otp;

  OtpEmailReq({required this.sessionId, required this.otp});

  OtpEmailReq copyWith({String? sessionId, String? otp}) =>
      OtpEmailReq(sessionId: sessionId ?? this.sessionId, otp: otp ?? this.otp);

  factory OtpEmailReq.fromJson(Map<String, dynamic> json) =>
      OtpEmailReq(sessionId: json["session_id"], otp: json["otp"]);

  Map<String, dynamic> toJson() => {"session_id": sessionId, "otp": otp};
}
