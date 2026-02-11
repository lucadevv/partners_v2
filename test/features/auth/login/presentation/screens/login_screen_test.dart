import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
import 'package:partners/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:partners/features/auth/login/presentation/login_screen.dart';
import 'package:partners/features/auth/login/presentation/login_screen_keys.dart';
import 'package:partners/features/auth/login/presentation/login_screen_strings.dart';

class MockOrquestorAuthCubit extends MockCubit<OrquestorAuthState>
    implements OrquestorAuthCubit {}

void main() {
  late MockOrquestorAuthCubit mockOrquestorAuthCubit;

  setUpAll(() {
    registerFallbackValue(OrquestorAuthState.initial());
  });

  setUp(() {
    mockOrquestorAuthCubit = MockOrquestorAuthCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: BlocProvider<OrquestorAuthCubit>.value(
        value: mockOrquestorAuthCubit,
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('muestra el formulario de login con textos y botón Continuar',
        (WidgetTester tester) async {
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(
        find.text(LoginScreenStrings.welcomeTitle),
        findsOneWidget,
      );
      expect(
        find.text(LoginScreenStrings.appName),
        findsOneWidget,
      );
      expect(
        find.text(LoginScreenStrings.subtitle),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(LoginScreenKeys.continueButton)),
        findsOneWidget,
      );
      expect(
        find.text(LoginScreenStrings.continueButton),
        findsOneWidget,
      );
      expect(
        find.text(LoginScreenStrings.forgotPassword),
        findsOneWidget,
      );
      expect(
        find.text(LoginScreenStrings.noAccount),
        findsOneWidget,
      );
      expect(
        find.text(LoginScreenStrings.registerFree),
        findsOneWidget,
      );
    });

    testWidgets('muestra indicador de carga cuando loginState es loading',
        (WidgetTester tester) async {
      final loadingState = OrquestorAuthState.initial().copyWith(
        loginState: const LoginState(status: LoginStatus.loading),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([loadingState]),
        initialState: loadingState,
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.continueButton)),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets('muestra SnackBar al enviar con email y contraseña vacíos',
        (WidgetTester tester) async {
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byKey(const Key(LoginScreenKeys.continueButton)));
      await tester.pumpAndSettle();

      expect(
        find.text(LoginScreenStrings.emptyFieldsSnackBar),
        findsOneWidget,
      );
      verifyNever(() => mockOrquestorAuthCubit.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });

    testWidgets('llama a login del cubit al enviar con email y contraseña',
        (WidgetTester tester) async {
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.emailField)),
          matching: find.byType(TextField),
        ),
        'test@test.com',
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.passwordField)),
          matching: find.byType(TextField),
        ),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key(LoginScreenKeys.continueButton)));
      await tester.pumpAndSettle();

      verify(() => mockOrquestorAuthCubit.login(
            email: 'test@test.com',
            password: 'password123',
          )).called(1);
    });

    testWidgets('muestra SnackBar de email inválido cuando el formato es incorrecto',
        (WidgetTester tester) async {
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([OrquestorAuthState.initial()]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.emailField)),
          matching: find.byType(TextField),
        ),
        'sinarroba',
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key(LoginScreenKeys.passwordField)),
          matching: find.byType(TextField),
        ),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key(LoginScreenKeys.continueButton)));
      await tester.pumpAndSettle();

      expect(
        find.text(LoginScreenStrings.invalidEmailFormat),
        findsOneWidget,
      );
      verifyNever(() => mockOrquestorAuthCubit.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });

    testWidgets('muestra SnackBar con mensaje de error cuando el login falla',
        (WidgetTester tester) async {
      const errorMessage = 'Credenciales inválidas';
      final failureState = OrquestorAuthState.initial().copyWith(
        loginState: LoginState(
          status: LoginStatus.failure,
          errorMessage: errorMessage,
        ),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([
          OrquestorAuthState.initial(),
          failureState,
        ]),
        initialState: OrquestorAuthState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('no muestra mensaje de error cuando el estado es success',
        (WidgetTester tester) async {
      final successState = OrquestorAuthState.initial().copyWith(
        loginState: LoginState(
          status: LoginStatus.success,
          responseEntity: null,
          errorMessage: null,
        ),
      );
      whenListen(
        mockOrquestorAuthCubit,
        Stream.fromIterable([successState]),
        initialState: successState,
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Credenciales inválidas'), findsNothing);
      expect(find.text(LoginScreenStrings.welcomeTitle), findsOneWidget);
    });
  });
}
