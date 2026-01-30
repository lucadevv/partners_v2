import 'package:equatable/equatable.dart';
import 'package:partners/features/auth/register/domain/entities/rep_legal_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/response/start_resgister_res_entity.dart';

abstract class RegisterState extends Equatable {}

enum RegisterStatus { initial, loading, success, failure }

class RegisterStateX extends RegisterState {
  final RegisterStatus sendRucStatus;
  final RegisterStatus sendDocStatus;
  final RegisterStatus sendStartStatus;

  final String? errorMessage;
  final RegisterResponseEntity rucData;
  final RepLegalResEntity docData;
  final StartRegisterResEntity startRegisterResEntity;

  RegisterStateX({
    required this.sendRucStatus,
    required this.sendDocStatus,
    required this.sendStartStatus,
    this.errorMessage,
    required this.rucData,
    required this.docData,
    required this.startRegisterResEntity,
  });

  RegisterStateX copyWith({
    RegisterStatus? sendRucStatus,
    RegisterStatus? sendDocStatus,
    RegisterStatus? sendStartStatus,
    String? errorMessage,
    RegisterResponseEntity? rucData,
    RepLegalResEntity? docData,
    StartRegisterResEntity? startRegisterResEntity,
  }) {
    return RegisterStateX(
      sendRucStatus: sendRucStatus ?? this.sendRucStatus,
      sendDocStatus: sendDocStatus ?? this.sendDocStatus,
      sendStartStatus: sendStartStatus ?? this.sendStartStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      rucData: rucData ?? this.rucData,
      docData: docData ?? this.docData,
      startRegisterResEntity:
          startRegisterResEntity ?? this.startRegisterResEntity,
    );
  }

  factory RegisterStateX.initial() {
    return RegisterStateX(
      sendRucStatus: RegisterStatus.initial,
      sendDocStatus: RegisterStatus.initial,
      sendStartStatus: RegisterStatus.initial,
      rucData: RegisterResponseEntity.empty(),
      docData: RepLegalResEntity.empty(),
      startRegisterResEntity: StartRegisterResEntity.empty(),
    );
  }
  @override
  List<Object?> get props => [
    sendRucStatus,
    sendDocStatus,
    sendStartStatus,
    errorMessage,
    rucData,
    docData,
  ];
}
