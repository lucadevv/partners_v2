class WhatsappValidationReq {
  final String sessionId;
  final String phone;

  WhatsappValidationReq({required this.sessionId, required this.phone});

  WhatsappValidationReq copyWith({String? sessionId, String? phone}) =>
      WhatsappValidationReq(
        sessionId: sessionId ?? this.sessionId,
        phone: phone ?? this.phone,
      );

  factory WhatsappValidationReq.fromJson(Map<String, dynamic> json) =>
      WhatsappValidationReq(
        sessionId: json["session_id"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "phone": phone,
      };
}
