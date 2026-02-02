class OtpWhatsappReq {
  final String sessionId;
  final String otp;

  OtpWhatsappReq({required this.sessionId, required this.otp});

  OtpWhatsappReq copyWith({String? sessionId, String? otp}) =>
      OtpWhatsappReq(
        sessionId: sessionId ?? this.sessionId,
        otp: otp ?? this.otp,
      );

  factory OtpWhatsappReq.fromJson(Map<String, dynamic> json) =>
      OtpWhatsappReq(
        sessionId: json["session_id"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "otp": otp,
      };
}
