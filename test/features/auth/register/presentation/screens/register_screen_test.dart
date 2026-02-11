import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_state.dart';
import 'package:partners/features/auth/register/presentation/register_screen.dart';
import 'package:partners/features/auth/register/presentation/register_screen_keys.dart';
import 'package:partners/features/auth/register/presentation/register_screen_strings.dart';

class MockRegisterCubit extends MockCubit<RegisterStateX> implements RegisterCubit {}

class MockOrquestorAuthCubit extends MockCubit<OrquestorAuthState>
    implements OrquestorAuthCubit {}

void main() {
  late MockRegisterCubit mockRegisterCubit;
  late MockOrquestorAuthCubit mockOrquestorAuthCubit;

  setUpAll(() {
    registerFallbackValue(RegisterStateX.initial());
    registerFallbackValue(OrquestorAuthState.initial());
  });

  setUp(() {
    mockRegisterCubit = MockRegisterCubit();
    mockOrquestorAuthCubit = MockOrquestorAuthCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<RegisterCubit>.value(value: mockRegisterCubit),
          BlocProvider<OrquestorAuthCubit>.value(value: mockOrquestorAuthCubit),
        ],
        child: const RegisterScreen(),
      ),
    );
  }

  group('RegisterScreen', () {
    testWidgets('muestra título, selectores RUC 10/15/20, campo RUC y botón Continuar',
        (WidgetTester tester) async {
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([RegisterStateX.initial()]),
        initialState: RegisterStateX.initial(),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(RegisterScreenStrings.title), findsOneWidget);
      expect(find.text(RegisterScreenStrings.ruc10), findsOneWidget);
      expect(find.text(RegisterScreenStrings.ruc15), findsOneWidget);
      expect(find.text(RegisterScreenStrings.ruc20), findsOneWidget);
      expect(find.text(RegisterScreenStrings.tipoComercio), findsNWidgets(3));
      expect(find.byKey(const Key(RegisterScreenKeys.rucField)), findsOneWidget);
      expect(find.text(RegisterScreenStrings.continueButton), findsOneWidget);
      expect(find.byKey(const Key(RegisterScreenKeys.continueButton)), findsOneWidget);
    });

    testWidgets('botón Continuar está deshabilitado cuando el formulario no está completo',
        (WidgetTester tester) async {
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([RegisterStateX.initial()]),
        initialState: RegisterStateX.initial(),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final continueButton = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byKey(const Key(RegisterScreenKeys.continueButton)),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(continueButton.onPressed, isNull);
    });

    testWidgets('muestra indicador de carga en campo RUC cuando sendRucStatus es loading',
        (WidgetTester tester) async {
      final loadingState = RegisterStateX.initial().copyWith(
        sendRucStatus: RegisterStatus.loading,
      );
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([loadingState]),
        initialState: loadingState,
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(
        find.descendant(
          of: find.byKey(const Key(RegisterScreenKeys.rucField)),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets('al tocar RUC 15 se llama reset del RegisterCubit',
        (WidgetTester tester) async {
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([RegisterStateX.initial()]),
        initialState: RegisterStateX.initial(),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text(RegisterScreenStrings.ruc15));
      await tester.pump();

      verify(() => mockRegisterCubit.reset()).called(1);
    });

    testWidgets('al tocar RUC 20 se llama reset del RegisterCubit',
        (WidgetTester tester) async {
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([RegisterStateX.initial()]),
        initialState: RegisterStateX.initial(),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text(RegisterScreenStrings.ruc20));
      await tester.pump();

      verify(() => mockRegisterCubit.reset()).called(1);
    });

    testWidgets('con sendRucStatus success y datos RUC el listener actualiza y el botón puede habilitarse',
        (WidgetTester tester) async {
      final successRucState = RegisterStateX.initial().copyWith(
        sendRucStatus: RegisterStatus.success,
        rucData: const RegisterResponseEntity(
          sessionId: 's1',
          ruc: '10123456789',
          isExists: false,
          socialReason: 'Razón Social Test',
        ),
      );
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([
          RegisterStateX.initial(),
          successRucState,
        ]),
        initialState: RegisterStateX.initial(),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final continueButton = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byKey(const Key(RegisterScreenKeys.continueButton)),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(continueButton.onPressed, isNotNull);
    });

    testWidgets('para RUC 20 muestra campos de tipo documento y documento',
        (WidgetTester tester) async {
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([RegisterStateX.initial()]),
        initialState: RegisterStateX.initial(),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text(RegisterScreenStrings.ruc20));
      await tester.pump();

      expect(find.byKey(const Key(RegisterScreenKeys.docField)), findsOneWidget);
    });

    testWidgets('muestra indicador de carga en campo documento cuando sendDocStatus es loading y RUC 20',
        (WidgetTester tester) async {
      final loadingDocState = RegisterStateX.initial().copyWith(
        sendDocStatus: RegisterStatus.loading,
      );
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([loadingDocState]),
        initialState: loadingDocState,
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text(RegisterScreenStrings.ruc20));
      await tester.pump();

      expect(
        find.descendant(
          of: find.byKey(const Key(RegisterScreenKeys.docField)),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets('muestra SnackBar y error en campo RUC cuando sendRucStatus es failure (error backend)',
        (WidgetTester tester) async {
      const errorBackend = 'Comercio no encontrado';
      final failureState = RegisterStateX.initial().copyWith(
        sendRucStatus: RegisterStatus.failure,
        errorMessage: errorBackend,
      );
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([RegisterStateX.initial(), failureState]),
        initialState: RegisterStateX.initial(),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text(errorBackend), findsWidgets);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('muestra SnackBar y error en campo documento cuando sendDocStatus es failure (RUC 20)',
        (WidgetTester tester) async {
      const errorBackend = 'Documento no válido';
      final failureDocState = RegisterStateX.initial().copyWith(
        sendDocStatus: RegisterStatus.failure,
        errorMessage: errorBackend,
      );
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([RegisterStateX.initial(), failureDocState]),
        initialState: RegisterStateX.initial(),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.tap(find.text(RegisterScreenStrings.ruc20));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text(errorBackend), findsWidgets);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('muestra SnackBar con mensaje por defecto cuando sendStartStatus es failure sin errorMessage',
        (WidgetTester tester) async {
      final failureStartState = RegisterStateX.initial().copyWith(
        sendStartStatus: RegisterStatus.failure,
        errorMessage: null,
      );
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([RegisterStateX.initial(), failureStartState]),
        initialState: RegisterStateX.initial(),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        find.text(RegisterScreenStrings.defaultErrorSnackBar),
        findsOneWidget,
      );
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
