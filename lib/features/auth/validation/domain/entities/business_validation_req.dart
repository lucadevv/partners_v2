import 'dart:io';

class BusinessValidationReq {
  final String sessionId;
  final File rucFile;

  BusinessValidationReq({
    required this.sessionId,
    required this.rucFile,
  });

  BusinessValidationReq copyWith({
    String? sessionId,
    File? rucFile,
  }) =>
      BusinessValidationReq(
        sessionId: sessionId ?? this.sessionId,
        rucFile: rucFile ?? this.rucFile,
      );
}
