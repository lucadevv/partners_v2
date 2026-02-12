import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/create_branch_params.dart';
import 'package:partners/features/branches/domain/domain.dart';
import 'package:partners/features/branches/domain/use_case/create_branch_usecase.dart';
import 'package:partners/features/branches/presentation/cubit/create_branch_cubit.dart';
import 'package:partners/features/branches/presentation/cubit/create_branch_state.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';

class MockCreateBranchUseCase extends Mock implements CreateBranchUseCase {}

/// Crea un notifier con formulario completo y válido para enviar.
CreateBranchFormNotifier createCompleteFormNotifier() {
  final notifier = CreateBranchFormNotifier();
  notifier.nameController.text = 'Sucursal Centro';
  notifier.phoneController.text = '999888777';
  notifier.addressController.text = 'Av Principal 123';
  notifier.setCategory(const CategoryEntity(id: 'cat1', name: 'Restaurante'));
  notifier.setSubCategory(const SubcategoryEntity(
    id: 'sub-1',
    categoryId: 'cat1',
    name: 'Cevichería',
  ));
  notifier.setSchedule(CreateBranchScreenStrings.scheduleMonSat);
  notifier.setScheduleData(
    [
      CreateBranchScreenStrings.scheduleModalDays[0],
      CreateBranchScreenStrings.scheduleModalDays[1],
    ],
    '09:00',
    '18:00',
  );
  notifier.setImagePath('/path/logo.jpg');
  notifier.setLatLng(-12.0464, -77.0428);
  notifier.validateAll();
  return notifier;
}

void main() {
  late MockCreateBranchUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(
      const CreateBranchParams(
        subcategoryId: '',
        name: '',
        address: '',
        latitude: 0,
        longitude: 0,
        phoneContacts: '',
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false,
        sunday: false,
        startTime: '',
        endTime: '',
      ),
    );
  });

  setUp(() {
    mockUseCase = MockCreateBranchUseCase();
  });

  tearDown(() {
    // Cerrar notifiers creados en tests para evitar leaks
  });

  group('CreateBranchCubit', () {
    test('estado inicial es CreateBranchState con status initial', () {
      final cubit = CreateBranchCubit(createBranchUseCase: mockUseCase);
      expect(cubit.state, const CreateBranchState());
      expect(cubit.state.status, CreateBranchStatus.initial);
      cubit.close();
    });

    blocTest<CreateBranchCubit, CreateBranchState>(
      'emite [loading, success] cuando el formulario es válido y el use case retorna Right',
      build: () {
        when(() => mockUseCase.call(any())).thenAnswer(
          (_) async => const Right('Sucursal creada correctamente'),
        );
        return CreateBranchCubit(createBranchUseCase: mockUseCase);
      },
      act: (cubit) {
        final notifier = createCompleteFormNotifier();
        cubit.createBranch(notifier);
        notifier.dispose();
      },
      expect: () => [
        const CreateBranchState(
          status: CreateBranchStatus.loading,
          errorMessage: null,
        ),
        const CreateBranchState(
          status: CreateBranchStatus.success,
          successMessage: 'Sucursal creada correctamente',
          errorMessage: null,
        ),
      ],
    );

    blocTest<CreateBranchCubit, CreateBranchState>(
      'emite [loading, failure] cuando el use case retorna Left',
      build: () {
        when(() => mockUseCase.call(any())).thenAnswer(
          (_) async =>
              const Left(ValidationException('Error al crear la sucursal')),
        );
        return CreateBranchCubit(createBranchUseCase: mockUseCase);
      },
      act: (cubit) {
        final notifier = createCompleteFormNotifier();
        cubit.createBranch(notifier);
        notifier.dispose();
      },
      expect: () => [
        const CreateBranchState(
          status: CreateBranchStatus.loading,
          errorMessage: null,
        ),
        const CreateBranchState(
          status: CreateBranchStatus.failure,
          errorMessage: 'Error al crear la sucursal',
        ),
      ],
    );

    blocTest<CreateBranchCubit, CreateBranchState>(
      'no llama al use case dos veces si ya está en loading',
      build: () {
        when(() => mockUseCase.call(any())).thenAnswer(
          (_) => Completer<Either<AppException, String>>().future,
        );
        return CreateBranchCubit(createBranchUseCase: mockUseCase);
      },
      act: (cubit) {
        final notifier = createCompleteFormNotifier();
        cubit.createBranch(notifier);
        cubit.createBranch(notifier);
        notifier.dispose();
      },
      expect: () => [
        const CreateBranchState(
          status: CreateBranchStatus.loading,
          errorMessage: null,
        ),
      ],
      verify: (_) {
        verify(() => mockUseCase.call(any())).called(1);
      },
    );

    blocTest<CreateBranchCubit, CreateBranchState>(
      'reset emite estado inicial',
      build: () {
        when(() => mockUseCase.call(any()))
            .thenAnswer((_) async => const Right('Ok'));
        return CreateBranchCubit(createBranchUseCase: mockUseCase);
      },
      seed: () => const CreateBranchState(
        status: CreateBranchStatus.failure,
        errorMessage: 'Error previo',
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [
        const CreateBranchState(
          status: CreateBranchStatus.initial,
          successMessage: null,
          errorMessage: null,
        ),
      ],
    );

    blocTest<CreateBranchCubit, CreateBranchState>(
      'emite failure "Debe seleccionar una imagen de banner" cuando el formulario está incompleto sin imagen',
      build: () => CreateBranchCubit(createBranchUseCase: mockUseCase),
      act: (cubit) {
        final notifier = CreateBranchFormNotifier();
        notifier.nameController.text = 'Sucursal';
        notifier.phoneController.text = '999888777';
        notifier.addressController.text = 'Av 123';
        notifier.setCategory(const CategoryEntity(id: 'c1', name: 'Cat'));
        notifier.setSubCategory(const SubcategoryEntity(
          id: 's1',
          categoryId: 'c1',
          name: 'Sub',
        ));
        notifier.setSchedule(CreateBranchScreenStrings.scheduleMonSat);
        notifier.setScheduleData(
          [CreateBranchScreenStrings.scheduleModalDays[0]],
          '09:00',
          '18:00',
        );
        notifier.setLatLng(-12.0, -77.0);
        // Sin imagen
        notifier.validateAll();
        cubit.createBranch(notifier);
        notifier.dispose();
      },
      expect: () => [
        const CreateBranchState(
          status: CreateBranchStatus.failure,
          errorMessage: 'Debe seleccionar una imagen de banner',
        ),
      ],
      verify: (_) {
        verifyNever(() => mockUseCase.call(any()));
      },
    );

    blocTest<CreateBranchCubit, CreateBranchState>(
      'emite failure "Debe seleccionar una subcategoría" cuando no hay subcategoría',
      build: () => CreateBranchCubit(createBranchUseCase: mockUseCase),
      act: (cubit) {
        final notifier = CreateBranchFormNotifier();
        notifier.nameController.text = 'Sucursal Centro';
        notifier.phoneController.text = '999888777';
        notifier.addressController.text = 'Av Principal 123';
        notifier.setCategory(const CategoryEntity(id: 'cat1', name: 'Restaurante'));
        // Sin subcategoría
        notifier.setSchedule(CreateBranchScreenStrings.scheduleMonSat);
        notifier.setScheduleData(
          [
            CreateBranchScreenStrings.scheduleModalDays[0],
            CreateBranchScreenStrings.scheduleModalDays[1],
          ],
          '09:00',
          '18:00',
        );
        notifier.setImagePath('/path/logo.jpg');
        notifier.setLatLng(-12.0464, -77.0428);
        notifier.validateAll();
        cubit.createBranch(notifier);
        notifier.dispose();
      },
      expect: () => [
        const CreateBranchState(
          status: CreateBranchStatus.failure,
          errorMessage: 'Debe seleccionar una subcategoría',
        ),
      ],
      verify: (_) {
        verifyNever(() => mockUseCase.call(any()));
      },
    );

    blocTest<CreateBranchCubit, CreateBranchState>(
      'no llama al use case cuando el formulario está incompleto (sin ubicación)',
      build: () => CreateBranchCubit(createBranchUseCase: mockUseCase),
      act: (cubit) {
        final notifier = CreateBranchFormNotifier();
        notifier.nameController.text = 'Sucursal Centro';
        notifier.phoneController.text = '999888777';
        notifier.addressController.text = 'Av Principal 123';
        notifier.setCategory(const CategoryEntity(id: 'cat1', name: 'Restaurante'));
        notifier.setSubCategory(const SubcategoryEntity(
          id: 'sub-1',
          categoryId: 'cat1',
          name: 'Cevichería',
        ));
        notifier.setSchedule(CreateBranchScreenStrings.scheduleMonSat);
        notifier.setScheduleData(
          [
            CreateBranchScreenStrings.scheduleModalDays[0],
            CreateBranchScreenStrings.scheduleModalDays[1],
          ],
          '09:00',
          '18:00',
        );
        notifier.setImagePath('/path/logo.jpg');
        // Sin setLatLng: isFormComplete será false, no se emite failure de imagen
        notifier.validateAll();
        cubit.createBranch(notifier);
        notifier.dispose();
      },
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockUseCase.call(any()));
      },
    );
  });
}
