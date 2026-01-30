import 'package:partners/core/utils/models/entity.dart';

class RegisterResponseEntity extends Entity {
  final String sessionId;
  final bool isExists;
  final String socialReason;

  const RegisterResponseEntity({
    required this.sessionId,
    required super.ruc,
    required this.isExists,
    required this.socialReason,
  });

  @override
  List<Object?> get props => [isExists, socialReason, sessionId];

  factory RegisterResponseEntity.empty() {
    return const RegisterResponseEntity(
      sessionId: '',
      ruc: '',
      isExists: false,
      socialReason: '',
    );
  }
  @override
  String getDisplayName() {
    return socialReason;
  }
}
