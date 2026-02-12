import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/core/services/location/location_service.dart';
import 'package:partners/core/services/mapbox/mapbox_geocoding_service.dart';
import 'package:partners/features/branches/presentation/cubit/create_branch_cubit.dart';
import 'package:partners/features/branches/presentation/cubit/create_branch_state.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_keys.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';
import 'package:partners/main.dart' show getIt;

class MockCreateBranchCubit extends MockCubit<CreateBranchState>
    implements CreateBranchCubit {}

class MockMapboxGeocodingService extends Mock implements MapboxGeocodingService {}

class MockLocationService extends Mock implements LocationService {}

void main() {
  late MockCreateBranchCubit mockCubit;
  late MockMapboxGeocodingService mockGeocoding;
  late MockLocationService mockLocation;

  setUpAll(() {
    registerFallbackValue(const CreateBranchState());
  });

  setUp(() {
    mockCubit = MockCreateBranchCubit();
    mockGeocoding = MockMapboxGeocodingService();
    mockLocation = MockLocationService();

    when(() => mockGeocoding.searchAddress(any())).thenAnswer((_) async => null);
    when(() => mockGeocoding.reverseGeocode(any(), any()))
        .thenAnswer((_) async => null);

    if (getIt.isRegistered<MapboxGeocodingService>()) {
      getIt.unregister<MapboxGeocodingService>();
    }
    getIt.registerSingleton<MapboxGeocodingService>(mockGeocoding);

    if (getIt.isRegistered<LocationService>()) {
      getIt.unregister<LocationService>();
    }
    getIt.registerSingleton<LocationService>(mockLocation);
  });

  tearDown(() {
    if (getIt.isRegistered<MapboxGeocodingService>()) {
      getIt.unregister<MapboxGeocodingService>();
    }
    if (getIt.isRegistered<LocationService>()) {
      getIt.unregister<LocationService>();
    }
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: BlocProvider<CreateBranchCubit>.value(
        value: mockCubit,
        child: const CreateBranchScreen(),
      ),
    );
  }

  group('CreateBranchScreen', () {
    testWidgets('muestra el título del app bar y el botón Crear nueva sucursal',
        (WidgetTester tester) async {
      whenListen(
        mockCubit,
        Stream.fromIterable([const CreateBranchState()]),
        initialState: const CreateBranchState(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(CreateBranchScreenStrings.appBarTitle),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(CreateBranchScreenKeys.createButton)),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key(CreateBranchScreenKeys.createButton)),
          matching: find.text(CreateBranchScreenStrings.createBranchButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets('muestra indicador de carga cuando el estado es loading',
        (WidgetTester tester) async {
      whenListen(
        mockCubit,
        Stream.fromIterable([
          const CreateBranchState(status: CreateBranchStatus.loading),
        ]),
        initialState: const CreateBranchState(
          status: CreateBranchStatus.loading,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final button = find.byKey(const Key(CreateBranchScreenKeys.createButton));
      expect(button, findsOneWidget);
      final elevatedButton = tester.widget<ElevatedButton>(button);
      expect(elevatedButton.onPressed, isNull);
    });

    testWidgets('muestra SnackBar con mensaje de éxito cuando el estado es success',
        (WidgetTester tester) async {
      const message = 'Sucursal creada correctamente';
      whenListen(
        mockCubit,
        Stream.fromIterable([
          const CreateBranchState(),
          const CreateBranchState(
            status: CreateBranchStatus.success,
            successMessage: message,
          ),
        ]),
        initialState: const CreateBranchState(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('muestra SnackBar con mensaje de error cuando el estado es failure',
        (WidgetTester tester) async {
      const errorMessage = 'Debe seleccionar una imagen de banner';
      whenListen(
        mockCubit,
        Stream.fromIterable([
          const CreateBranchState(),
          const CreateBranchState(
            status: CreateBranchStatus.failure,
            errorMessage: errorMessage,
          ),
        ]),
        initialState: const CreateBranchState(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('el botón Crear está deshabilitado cuando el formulario está vacío',
        (WidgetTester tester) async {
      whenListen(
        mockCubit,
        Stream.fromIterable([const CreateBranchState()]),
        initialState: const CreateBranchState(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final button = find.byKey(const Key(CreateBranchScreenKeys.createButton));
      expect(button, findsOneWidget);
      final elevatedButton = tester.widget<ElevatedButton>(button);
      expect(elevatedButton.onPressed, isNull);
    });
  });
}
