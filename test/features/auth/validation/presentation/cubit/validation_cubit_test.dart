import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/features/auth/validation/presentation/cubit/validation_cubit.dart';

void main() {
  group('ValidationCubit', () {
    late ValidationCubit cubit;

    setUp(() {
      cubit = ValidationCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is ValidationState with initial status', () {
      expect(cubit.state, const ValidationState());
      expect(cubit.state.status, ValidationStatus.initial);
      expect(cubit.state.completedSteps, isEmpty);
    });

    group('validateEmail', () {
      blocTest<ValidationCubit, ValidationState>(
        'emits [loading, otpSent] when email validation succeeds',
        build: () => cubit,
        act: (cubit) => cubit.validateEmail('test@example.com'),
        expect: () => [
          const ValidationState(status: ValidationStatus.loading),
          const ValidationState(
            status: ValidationStatus.otpSent,
            validationType: ValidationType.email,
            value: 'test@example.com',
          ),
        ],
      );
    });

    group('verifyEmailOtp', () {
      blocTest<ValidationCubit, ValidationState>(
        'emits [loading, stepCompleted] when OTP is valid',
        build: () => cubit,
        act: (cubit) => cubit.verifyEmailOtp('12345'),
        expect: () => [
          const ValidationState(status: ValidationStatus.loading),
          isA<ValidationState>()
              .having((s) => s.status, 'status', ValidationStatus.stepCompleted)
              .having(
                (s) => s.completedSteps,
                'completedSteps',
                contains(ValidationType.email),
              )
              .having((s) => s.effect, 'effect', isA<EmailCompletedEffect>()),
        ],
      );
    });

    group('validateWhatsApp', () {
      blocTest<ValidationCubit, ValidationState>(
        'emits [loading, otpSent] when WhatsApp validation succeeds',
        build: () => cubit,
        act: (cubit) => cubit.validateWhatsApp('987654321'),
        expect: () => [
          const ValidationState(status: ValidationStatus.loading),
          const ValidationState(
            status: ValidationStatus.otpSent,
            validationType: ValidationType.whatsapp,
            value: '987654321',
          ),
        ],
      );
    });

    group('verifyWhatsAppOtp', () {
      blocTest<ValidationCubit, ValidationState>(
        'emits [loading, stepCompleted] when OTP is valid',
        build: () => cubit,
        act: (cubit) => cubit.verifyWhatsAppOtp('12345'),
        expect: () => [
          const ValidationState(status: ValidationStatus.loading),
          isA<ValidationState>()
              .having((s) => s.status, 'status', ValidationStatus.stepCompleted)
              .having(
                (s) => s.completedSteps,
                'completedSteps',
                contains(ValidationType.whatsapp),
              )
              .having((s) => s.effect, 'effect', isA<WhatsAppCompletedEffect>()),
        ],
      );
    });

    group('savePassword', () {
      blocTest<ValidationCubit, ValidationState>(
        'emits [loading, stepCompleted] when password is saved',
        build: () => cubit,
        act: (cubit) => cubit.savePassword('securePass123'),
        expect: () => [
          const ValidationState(status: ValidationStatus.loading),
          isA<ValidationState>()
              .having((s) => s.status, 'status', ValidationStatus.stepCompleted)
              .having(
                (s) => s.completedSteps,
                'completedSteps',
                contains(ValidationType.password),
              )
              .having((s) => s.effect, 'effect', isA<PasswordCompletedEffect>()),
        ],
      );
    });

    group('documentValidated', () {
      blocTest<ValidationCubit, ValidationState>(
        'emits stepCompleted with document in completedSteps',
        build: () => cubit,
        act: (cubit) => cubit.documentValidated(),
        expect: () => [
          isA<ValidationState>()
              .having((s) => s.status, 'status', ValidationStatus.stepCompleted)
              .having(
                (s) => s.completedSteps,
                'completedSteps',
                contains(ValidationType.document),
              )
              .having((s) => s.effect, 'effect', isA<DocumentCompletedEffect>()),
        ],
      );
    });

    group('checkAllCompleted', () {
      blocTest<ValidationCubit, ValidationState>(
        'emits allCompleted when all 4 validations are done',
        build: () => cubit,
        seed: () => const ValidationState(
          completedSteps: {
            ValidationType.email,
            ValidationType.whatsapp,
            ValidationType.password,
            ValidationType.document,
          },
        ),
        act: (cubit) => cubit.checkAllCompleted(),
        expect: () => [
          isA<ValidationState>()
              .having((s) => s.status, 'status', ValidationStatus.allCompleted)
              .having(
                (s) => s.effect,
                'effect',
                isA<AllValidationsCompletedEffect>(),
              ),
        ],
      );

      blocTest<ValidationCubit, ValidationState>(
        'does not emit allCompleted when validations are incomplete',
        build: () => cubit,
        seed: () => const ValidationState(
          completedSteps: {
            ValidationType.email,
            ValidationType.whatsapp,
          },
        ),
        act: (cubit) => cubit.checkAllCompleted(),
        expect: () => [],
      );
    });

    group('clearEffect', () {
      blocTest<ValidationCubit, ValidationState>(
        'clears the effect from state',
        build: () => cubit,
        seed: () => const ValidationState(
          effect: EmailCompletedEffect(),
        ),
        act: (cubit) => cubit.clearEffect(),
        expect: () => [
          const ValidationState(effect: null),
        ],
      );
    });

    group('reset', () {
      blocTest<ValidationCubit, ValidationState>(
        'resets to initial state',
        build: () => cubit,
        seed: () => const ValidationState(
          status: ValidationStatus.stepCompleted,
          completedSteps: {ValidationType.email, ValidationType.whatsapp},
        ),
        act: (cubit) => cubit.reset(),
        expect: () => [
          const ValidationState(),
        ],
      );
    });
  });
}
