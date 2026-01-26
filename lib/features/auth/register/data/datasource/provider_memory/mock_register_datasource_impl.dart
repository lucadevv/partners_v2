// import 'package:dartz/dartz.dart';
// import 'package:partners/core/utils/exeptions/app_exceptions.dart';
// import 'package:partners/features/auth/register/data/datasource/register_datasource.dart';
// import 'package:partners/features/auth/register/data/models/register_ruc_res_model.dart';
// import 'package:partners/features/auth/register/domain/entities/register_entity.dart';
// import 'package:partners/features/auth/register/domain/entities/tipo_comercio.dart';
// import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';

// class MockRegisterDatasourceImpl implements RegisterDatasource {
//   // Mock data para diferentes documentos y tipos de RUC
//   // final Map<String, Map<String, RegisterResponseModel>> _mockData = {
//   //   // RUC 10 - DNI
//   //   'ruc10_dni': {
//   //     '12345678': RegisterResponseModel(
//   //       nombres: 'Juan Carlos',
//   //       apellidos: 'Pérez García',
//   //     ),
//   //     '87654321': RegisterResponseModel(
//   //       nombres: 'María Elena',
//   //       apellidos: 'Rodríguez López',
//   //     ),
//   //     '11223344': RegisterResponseModel(
//   //       nombres: 'Pedro Antonio',
//   //       apellidos: 'González Silva',
//   //     ),
//   //   },
//   //   // RUC 10 - CE
//   //   'ruc10_ce': {
//   //     '123456789': RegisterResponseModel(
//   //       nombres: 'Ana Sofía',
//   //       apellidos: 'Martínez Torres',
//   //     ),
//   //     '987654321': RegisterResponseModel(
//   //       nombres: 'Luis Fernando',
//   //       apellidos: 'Hernández Vargas',
//   //     ),
//   //   },
//   //   // RUC 15 - DNI
//   //   'ruc15_dni': {
//   //     '12345678': RegisterResponseModel(
//   //       nombres: 'Carlos Alberto',
//   //       apellidos: 'Sánchez Mendoza',
//   //     ),
//   //     '87654321': RegisterResponseModel(
//   //       nombres: 'Laura Patricia',
//   //       apellidos: 'Díaz Ramírez',
//   //     ),
//   //   },
//   //   // RUC 15 - CE
//   //   'ruc15_ce': {
//   //     '123456789': RegisterResponseModel(
//   //       nombres: 'Roberto José',
//   //       apellidos: 'Morales Castro',
//   //     ),
//   //   },
//   //   // RUC 20 - DNI
//   //   'ruc20_dni': {
//   //     '12345678': RegisterResponseModel(
//   //       razonSocial: 'EMPRESA COMERCIAL S.A.C.',
//   //     ),
//   //     '87654321': RegisterResponseModel(
//   //       razonSocial: 'NEGOCIOS Y SERVICIOS E.I.R.L.',
//   //     ),
//   //     '11223344': RegisterResponseModel(
//   //       razonSocial: 'INVERSIONES PERUANAS S.A.',
//   //     ),
//   //   },
//   //   // RUC 20 - CE
//   //   'ruc20_ce': {
//   //     '123456789': RegisterResponseModel(
//   //       razonSocial: 'COMERCIO INTERNACIONAL S.A.C.',
//   //     ),
//   //   },
//   // };

//   // // Mock data para representantes legales (RUC 20)
//   // final Map<String, RegisterResponseModel> _mockRepresentantes = {
//   //   '12345678': RegisterResponseModel(
//   //     nombres: 'Roberto',
//   //     apellidos: 'García Morales',
//   //   ),
//   //   '87654321': RegisterResponseModel(
//   //     nombres: 'Carmen',
//   //     apellidos: 'Vega Sánchez',
//   //   ),
//   //   '11223344': RegisterResponseModel(
//   //     nombres: 'Fernando',
//   //     apellidos: 'Torres López',
//   //   ),
//   //   '123456789': RegisterResponseModel(
//   //     nombres: 'Patricia',
//   //     apellidos: 'Mendoza Díaz',
//   //   ),
//   //   '987654321': RegisterResponseModel(
//   //     nombres: 'Jorge',
//   //     apellidos: 'Ramírez Castro',
//   //   ),
//   // };

//   @override
//   Future<Either<AppException, TResponse>> validateComerce<TRequest, TResponse>(
//     TRequest request,
//   ) async {
//     await Future.delayed(const Duration(milliseconds: 500));

//     if (request is! RegisterEntity) {
//       return Left(ValidationException('Invalid request type'));
//     }

//     final entity = request;

//     // Validar que tenga los datos necesarios
//     if (entity.numeroDocumento == null || entity.numeroDocumento!.isEmpty) {
//       return Left(ValidationException('Número de documento requerido'));
//     }

//     if (entity.tipoComercio == null) {
//       return Left(ValidationException('Tipo de comercio requerido'));
//     }

//     // Para RUC 10 y 15, usar DNI por defecto si no se especifica
//     final tipoDocumento = entity.tipoDocumento ?? TipoDocumento.dni;

//     // Para RUC 20, validar documento del representante
//     if (entity.tipoComercio == TipoComercio.ruc20) {
//       if (entity.numeroDocumentoRepresentante == null ||
//           entity.numeroDocumentoRepresentante!.isEmpty) {
//         // Si no hay documento de representante, retornar solo razón social
//         // Para RUC 20, buscar en datos de DNI por defecto
//         final key = '${entity.tipoComercio!.toString().split('.').last}_dni';
//         final dataMap = _mockData[key];
//         final mockResponse =
//             dataMap?[entity.numeroDocumento!] ??
//             RegisterResponseModel(razonSocial: 'EMPRESA COMERCIAL S.A.C.');
//         return Right(mockResponse.toEntity() as TResponse);
//       }

//       // Validar representante y retornar sus datos
//       final representante =
//           _mockRepresentantes[entity.numeroDocumentoRepresentante!] ??
//           RegisterResponseModel(nombres: 'Representante', apellidos: 'Legal');

//       // También incluir razón social si existe (buscar en datos de DNI por defecto)
//       final key = '${entity.tipoComercio!.toString().split('.').last}_dni';
//       final dataMap = _mockData[key];
//       final razonSocial = dataMap?[entity.numeroDocumento!]?.razonSocial;

//       return Right(
//         RegisterResponseModel(
//               nombres: representante.nombres,
//               apellidos: representante.apellidos,
//               razonSocial: razonSocial,
//             ).toEntity()
//             as TResponse,
//       );
//     }

//     // Para RUC 10 y 15, buscar en mock data (usando DNI por defecto)
//     final key = _getKey(entity.tipoComercio!, tipoDocumento);
//     final dataMap = _mockData[key];
//     final mockResponse =
//         dataMap?[entity.numeroDocumento!] ??
//         RegisterResponseModel(nombres: 'Usuario', apellidos: 'Prueba');

//     return Right(mockResponse.toEntity() as TResponse);
//   }

//   String _getKey(TipoComercio tipoComercio, TipoDocumento tipoDocumento) {
//     final tipoComercioStr = tipoComercio.toString().split('.').last;
//     final tipoDocumentoStr = tipoDocumento.toString().split('.').last;
//     return '${tipoComercioStr}_$tipoDocumentoStr';
//   }
// }
