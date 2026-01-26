// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
// import 'package:partners/features/auth/register/data/datasource/register_mock_datasource.dart';
// import 'package:partners/features/auth/register/data/repository/register_repository_impl.dart';
// import 'package:partners/features/auth/register/domain/use_case/validate_commerce_usecase.dart';
// import 'package:partners/features/auth/validation/presentation/cubit/validation_cubit.dart';
// import 'package:partners/features/auth/document_scan/presentation/cubit/document_scan_cubit.dart';
// import 'package:partners/features/auth/business_validation/presentation/cubit/business_validation_cubit.dart';
// import 'package:partners/features/auth/orquestador/cubit/orquestador_auth_cubit.dart';
// import 'package:partners/features/auth/register/presentation/register_screen.dart';

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   group('Flujo Completo de Registro RUC 10', () {
//     testWidgets('Usuario completa registro con RUC 10 exitosamente', (
//       WidgetTester tester,
//     ) async {
//       // Configurar mock datasource
//       final mockDataSource = RegisterMockDatasource();
//       final repository = RegisterRepositoryImpl(
//         registerDatasource: mockDataSource,
//       );
//       final validateComerceUseCase = ValidateCommerceUsecase(
//         repository: repository,
//       );

//       // Crear cubits
//       final registerCubit = RegisterCubit(
//         validateCommerceUsecase: validateComerceUseCase,
//       );
//       final validationCubit = ValidationCubit();
//       final documentScanCubit = DocumentScanCubit();
//       final orquestadorCubit = OrquestadorAuthCubit();

//       // Iniciar la app con el register screen
//       await tester.pumpWidget(
//         MaterialApp(
//           home: MultiBlocProvider(
//             providers: [
//               BlocProvider.value(value: registerCubit),
//               BlocProvider.value(value: validationCubit),
//               BlocProvider.value(value: documentScanCubit),
//               BlocProvider.value(value: orquestadorCubit),
//             ],
//             child: const RegisterScreen(),
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();

//       // PASO 1: Seleccionar RUC 10
//       await tester.tap(find.text('RUC 10'));
//       await tester.pumpAndSettle();

//       expect(find.text('RUC 10'), findsWidgets);

//       // PASO 2: Ingresar número de documento
//       await tester.enterText(
//         find.widgetWithText(TextField, 'Ingrese el RUC del negocio').first,
//         '10733456723',
//       );
//       await tester.pumpAndSettle();

//       // PASO 3: Presionar continuar
//       await tester.tap(find.text('Continuar'));
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       // VERIFICAR: Nombres auto-completados
//       expect(find.text('Anderson J., Moscol Sicha'), findsOneWidget);
//     });
//   });

//   group('Flujo Completo de Registro RUC 20', () {
//     testWidgets('Usuario completa registro con RUC 20 exitosamente', (
//       WidgetTester tester,
//     ) async {
//       // Configurar mock datasource
//       final mockDataSource = RegisterMockDatasource();
//       final repository = RegisterRepositoryImpl(
//         registerDatasource: mockDataSource,
//       );
//       final validateComerceUseCase = ValidateCommerceUsecase(
//         repository: repository,
//       );

//       // Crear cubits
//       final registerCubit = RegisterCubit(
//         validateCommerceUsecase: validateComerceUseCase,
//       );
//       final validationCubit = ValidationCubit();
//       final documentScanCubit = DocumentScanCubit();
//       final businessValidationCubit = BusinessValidationCubit();
//       final orquestadorCubit = OrquestadorAuthCubit();

//       // Iniciar la app con el register screen
//       await tester.pumpWidget(
//         MaterialApp(
//           home: MultiBlocProvider(
//             providers: [
//               BlocProvider.value(value: registerCubit),
//               BlocProvider.value(value: validationCubit),
//               BlocProvider.value(value: documentScanCubit),
//               BlocProvider.value(value: businessValidationCubit),
//               BlocProvider.value(value: orquestadorCubit),
//             ],
//             child: const RegisterScreen(),
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();

//       // PASO 1: Seleccionar RUC 20
//       await tester.tap(find.text('RUC 20'));
//       await tester.pumpAndSettle();

//       expect(find.text('RUC 20'), findsWidgets);

//       // PASO 2: Ingresar RUC de la empresa
//       await tester.enterText(
//         find.widgetWithText(TextField, 'Ingrese el RUC del negocio').first,
//         '20605999558',
//       );
//       await tester.pumpAndSettle();

//       // PASO 3: Presionar continuar
//       await tester.tap(find.text('Continuar'));
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       // VERIFICAR: Razón social auto-completada
//       expect(find.text('MARKETRIX S.A.C.'), findsOneWidget);

//       // VERIFICAR: Campos adicionales de RUC 20 visibles
//       expect(find.text('Tipo de documento'), findsWidgets);
//       expect(find.text('Nombre de la empresa'), findsOneWidget);
//     });
//   });

//   group('Validación de Errores', () {
//     testWidgets('Muestra error cuando el documento es inválido', (
//       WidgetTester tester,
//     ) async {
//       // Configurar mock datasource
//       final mockDataSource = RegisterMockDatasource();
//       final repository = RegisterRepositoryImpl(
//         registerDatasource: mockDataSource,
//       );
//       final validateComerceUseCase = ValidateCommerceUsecase(
//         repository: repository,
//       );

//       // Crear cubit
//       final registerCubit = RegisterCubit(
//         validateCommerceUsecase: validateComerceUseCase,
//       );

//       // Iniciar la app
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider.value(
//             value: registerCubit,
//             child: const RegisterScreen(),
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();

//       // Seleccionar RUC 10
//       await tester.tap(find.text('RUC 10'));
//       await tester.pumpAndSettle();

//       // Ingresar documento inválido (muy corto)
//       await tester.enterText(
//         find.widgetWithText(TextField, 'Ingrese el RUC del negocio').first,
//         '123',
//       );
//       await tester.pumpAndSettle();

//       // Presionar continuar
//       await tester.tap(find.text('Continuar'));
//       await tester.pumpAndSettle();

//       // VERIFICAR: Mensaje de error aparece
//       expect(find.text('Por favor complete todos los campos'), findsOneWidget);
//     });
//   });
// }
