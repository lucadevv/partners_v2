import 'package:equatable/equatable.dart';
import 'package:partners/core/utils/enums/enums.dart';

class StartRegisterReq extends Equatable {
  final String sessionId;
  final RucType rucType;

  const StartRegisterReq({required this.sessionId, required this.rucType});

  Map<String, String> toJson() {
    return {'session_id': sessionId, 'company_type': rucType.name};
  }

  @override
  List<Object?> get props => [sessionId, rucType];
}
