import 'package:equatable/equatable.dart';

class RegisterResponseEntity extends Equatable {
  final bool isExists;
  final String? socialReason;

  const RegisterResponseEntity({
    required this.isExists,
    required this.socialReason,
  });

  @override
  List<Object?> get props => [isExists, socialReason];
}
