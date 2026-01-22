import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/features/auth/register/presentation/register_screen.dart';

class MockRegisterCubit extends Mock implements RegisterCubit {}

void main() {
  group('RegisterScreen Widget Tests', () {
    late MockRegisterCubit mockCubit;

    setUp(() {
      mockCubit = MockRegisterCubit();
      when(() => mockCubit.state).thenReturn(RegisterState.initial());
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('should display RUC selector with 3 options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<RegisterCubit>.value(
            value: mockCubit,
            child: const RegisterScreen(),
          ),
        ),
      );

      // Verificar que el selector de RUC se muestra
      expect(find.text('RUC 10'), findsOneWidget);
      expect(find.text('RUC 15'), findsOneWidget);
      expect(find.text('RUC 20'), findsOneWidget);
    });

    testWidgets('should display document number field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<RegisterCubit>.value(
            value: mockCubit,
            child: const RegisterScreen(),
          ),
        ),
      );

      // Verificar que el campo de documento se muestra
      expect(find.text('Nro. de documento'), findsWidgets);
    });

    testWidgets('should display continue button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<RegisterCubit>.value(
            value: mockCubit,
            child: const RegisterScreen(),
          ),
        ),
      );

      // Verificar que el botón continuar se muestra
      expect(find.text('Continuar'), findsOneWidget);
    });

    testWidgets('should show names field when RUC 10 is selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<RegisterCubit>.value(
            value: mockCubit,
            child: const RegisterScreen(),
          ),
        ),
      );

      // Tap en RUC 10
      await tester.tap(find.text('RUC 10'));
      await tester.pumpAndSettle();

      // Verificar que el campo de nombres se muestra
      expect(find.text('Nombres del registrante'), findsOneWidget);
    });

    testWidgets('should show additional fields when RUC 20 is selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<RegisterCubit>.value(
            value: mockCubit,
            child: const RegisterScreen(),
          ),
        ),
      );

      // Tap en RUC 20
      await tester.tap(find.text('RUC 20'));
      await tester.pumpAndSettle();

      // Verificar campos adicionales para RUC 20
      expect(find.text('Nombre de la empresa'), findsOneWidget);
      expect(find.text('Tipo de documento'), findsWidgets);
    });

    testWidgets('continue button should be disabled when loading', (
      tester,
    ) async {
      when(
        () => mockCubit.state,
      ).thenReturn(const RegisterState(status: RegisterStatus.loading));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<RegisterCubit>.value(
            value: mockCubit,
            child: const RegisterScreen(),
          ),
        ),
      );

      // Verificar que el botón está deshabilitado
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Continuar'),
      );
      expect(button.onPressed, isNull);
    });
  });
}
