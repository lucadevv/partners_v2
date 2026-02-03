part of 'validation_cubit.dart';

enum ValidationStatus { initial, loading, success, failure }

class ValidationState extends Equatable {
  final ValidationStatus stepsStatus;
  final String? errorMessage;
  final StepsResEntity stepsEntity;
  final List<ItemValidation> validationItems;
  final String nextStep;
  final RucType? rucType;

  const ValidationState({
    required this.stepsStatus,
    this.errorMessage,
    required this.stepsEntity,
    this.validationItems = const [],
    this.nextStep = '',
    this.rucType,
  });

  ValidationState copyWith({
    ValidationStatus? stepsStatus,
    String? errorMessage,
    StepsResEntity? stepsEntity,
    List<ItemValidation>? validationItems,
    String? nextStep,
    RucType? rucType,
  }) {
    return ValidationState(
      stepsStatus: stepsStatus ?? this.stepsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      stepsEntity: stepsEntity ?? this.stepsEntity,
      validationItems: validationItems ?? this.validationItems,
      nextStep: nextStep ?? this.nextStep,
      rucType: rucType ?? this.rucType,
    );
  }

  factory ValidationState.initial() {
    return ValidationState(
      stepsStatus: ValidationStatus.initial,
      errorMessage: null,
      stepsEntity: StepsResEntity.empty(),
      validationItems: ItemFactory.getConfig(),
    );
  }

  bool get isLoading => stepsStatus == ValidationStatus.loading;
  bool get hasError => stepsStatus == ValidationStatus.failure;
  bool get isSuccess => stepsStatus == ValidationStatus.success;

  @override
  List<Object?> get props => [
    stepsStatus,
    errorMessage,
    stepsEntity,
    validationItems,
    nextStep,
    rucType,
  ];
}
