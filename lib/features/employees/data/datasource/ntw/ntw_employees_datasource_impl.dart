import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/exception_handler.dart';
import 'package:partners/core/utils/image_compression_helper.dart';
import 'package:partners/features/employees/data/datasource/employees_datasource.dart';
import 'package:partners/features/employees/data/models/employee_detail_response_model.dart';
import 'package:partners/features/employees/data/models/employees_branch_response_model.dart';
import 'package:partners/features/employees/data/models/options_branches_response_model.dart';
import 'package:partners/features/employees/data/models/options_roles_response_model.dart';
import 'package:partners/features/employees/domain/entities/create_employee_params.dart';
import 'package:partners/features/employees/domain/entities/update_employee_params.dart';

/// Implementación de [EmployeesDatasource] vía API.
class NtwEmployeesDatasourceImpl implements EmployeesDatasource {
  NtwEmployeesDatasourceImpl({required ApiServices services})
    : _services = services;

  final ApiServices _services;

  @override
  Future<Either<AppException, EmployeesBranchResponseModel>> getEmployeesBranch(
    int page,
  ) async {
    try {
      final response = await _services.get(
        '/employees-branch',
        queryParameters: <String, dynamic>{'page': page},
      );
      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de empleados vacía',
            details: 'data is null',
          ),
        );
      }
      final map = data is Map<String, dynamic> ? data : null;
      if (map == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de empleados inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }
      final model = EmployeesBranchResponseModel.fromJson(map);
      return Right(model);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'employees_get');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, EmployeeDetailResponseModel>> getEmployeeById(
    String id,
  ) async {
    try {
      final response = await _services.get('/employees-branch/$id');
      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de detalle de empleado vacía',
            details: 'data is null',
          ),
        );
      }
      final map = data is Map<String, dynamic> ? data : null;
      if (map == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de empleado inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }
      final model = EmployeeDetailResponseModel.fromJson(map);
      return Right(model);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'employees_get_by_id');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, OptionsBranchesResponseModel>>
  getOptionsBranches() async {
    try {
      final response = await _services.get('/options/branches');
      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de opciones de sucursales vacía',
            details: 'data is null',
          ),
        );
      }
      final map = data is Map<String, dynamic> ? data : null;
      if (map == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de opciones de sucursales inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }
      final model = OptionsBranchesResponseModel.fromJson(map);
      return Right(model);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'options_branches');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, OptionsRolesResponseModel>>
  getOptionsRoles() async {
    try {
      final response = await _services.get('/options/roles');
      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de opciones de roles vacía',
            details: 'data is null',
          ),
        );
      }
      final map = data is Map<String, dynamic> ? data : null;
      if (map == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de roles inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }
      final model = OptionsRolesResponseModel.fromJson(map);
      return Right(model);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'options_roles');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, String>> createEmployee(
    CreateEmployeeParams params,
  ) async {
    try {
      final map = <String, dynamic>{
        'email': params.email,
        'password': params.password,
        'name': params.name,
        'last_name': params.lastName,
        'branch_id': params.branchId,
        'role_id': params.roleId,
      };
      if (params.photoPath != null &&
          params.photoPath!.isNotEmpty &&
          params.photoPath != 'placeholder') {
        final pathToSend =
            await compressImageFile(params.photoPath!) ?? params.photoPath!;
        map['photo'] = await MultipartFile.fromFile(
          pathToSend,
          filename: pathToSend.split('/').last,
        );
      }
      final formData = FormData.fromMap(map);

      final response = await _services.post(
        '/employees-branch',
        data: formData,
        isFormData: true,
      );

      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de creación de empleado vacía',
            details: 'data is null',
          ),
        );
      }
      final mapBody = data is Map<String, dynamic> ? data : null;
      if (mapBody == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de creación inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }
      final message = mapBody['message'] as String?;
      if (message == null || message.isEmpty) {
        return Left(
          UnknownException(
            'La respuesta no contiene el campo message',
            details: mapBody.toString(),
          ),
        );
      }
      return Right(message);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'employees_create');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, String>> updateEmployee(
    String id,
    UpdateEmployeeParams params,
  ) async {
    try {
      final map = <String, dynamic>{
        'email': params.email,
        'name': params.name,
        'last_name': params.lastName,
        'branch_id': params.branchId,
        'role_id': params.roleId,
      };
      if (params.photoPath != null &&
          params.photoPath!.isNotEmpty &&
          params.photoPath != 'placeholder') {
        final pathToSend =
            await compressImageFile(params.photoPath!) ?? params.photoPath!;
        map['photo'] = await MultipartFile.fromFile(
          pathToSend,
          filename: pathToSend.split('/').last,
        );
      }
      final formData = FormData.fromMap(map);

      final response = await _services.post(
        '/employees-branch/$id',
        data: formData,
        isFormData: true,
      );

      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de actualización vacía',
            details: 'data is null',
          ),
        );
      }
      final mapBody = data is Map<String, dynamic> ? data : null;
      if (mapBody == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de actualización inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }
      final message = mapBody['message'] as String?;
      if (message == null || message.isEmpty) {
        return Left(
          UnknownException(
            'La respuesta no contiene el campo message',
            details: mapBody.toString(),
          ),
        );
      }
      return Right(message);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'employees_update');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, String>> deleteEmployee(String id) async {
    try {
      final response = await _services.delete('/employees-branch/$id');
      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de eliminación vacía',
            details: 'data is null',
          ),
        );
      }
      final mapBody = data is Map<String, dynamic> ? data : null;
      if (mapBody == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de eliminación inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }
      final message = mapBody['message'] as String?;
      if (message == null || message.isEmpty) {
        return Left(
          UnknownException(
            'La respuesta no contiene el campo message',
            details: mapBody.toString(),
          ),
        );
      }
      return Right(message);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'employees_delete');
      return Left(appException);
    }
  }
}
