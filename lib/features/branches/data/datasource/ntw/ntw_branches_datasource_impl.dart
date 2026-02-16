import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/exception_handler.dart';
import 'package:partners/features/branches/data/datasource/branches_datasource.dart';
import 'package:partners/features/branches/data/models/branch_detail_model.dart';
import 'package:partners/features/branches/data/models/branch_model.dart';
import 'package:partners/features/branches/data/models/category_response_model.dart';
import 'package:partners/features/branches/data/models/subcategory_response_model.dart';
import 'package:partners/features/branches/domain/entities/create_branch_params.dart';

/// Implementación de [BranchesDatasource]: GET /branch para lista, API para categorías/subcategorías y POST para crear.
class NtwBranchesDatasourceImpl implements BranchesDatasource {
  final ApiServices _services;

  NtwBranchesDatasourceImpl({required ApiServices services})
      : _services = services;

  @override
  Future<Either<AppException, List<BranchModel>>> getBranches() async {
    try {
      final response = await _services.get('/branch');
      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de sucursales vacía',
            details: 'data is null',
          ),
        );
      }
      final map = data is Map<String, dynamic> ? data : null;
      if (map == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de sucursales inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }
      final list = BranchModel.listFromJson(map);
      return Right(list);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'branches_get');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, BranchDetailModel>> getBranchById(String id) async {
    try {
      final response = await _services.get('/branch/$id');
      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de detalle de sucursal vacía',
            details: 'data is null',
          ),
        );
      }
      final map = data is Map<String, dynamic> ? data : null;
      if (map == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de detalle inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }
      // Backend puede devolver { "data": { id, name, ... } } o el objeto en la raíz
      final body = map['data'] is Map<String, dynamic>
          ? map['data'] as Map<String, dynamic>
          : map;
      final model = BranchDetailModel.fromJson(body);
      return Right(model);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'branches_get_by_id');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, CategoryResponseModel>> getCategories(
    int page, {
    String? keyword,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (keyword != null && keyword.isNotEmpty) {
        queryParams['keyword'] = keyword;
      }
      final response = await _services.get(
        '/options/categories',
        queryParameters: queryParams,
      );
      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de categorías vacía',
            details: 'data is null',
          ),
        );
      }

      final map = data is Map<String, dynamic> ? data : null;
      if (map == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de categorías inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }

      final model = CategoryResponseModel.fromJson(map);
      return Right(model);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'branches_categories');
      return Left(appException);
    }
  }

  @override
  Future<Either<AppException, SubcategoryResponseModel>> getSubcategories(
    String categoryId,
    int page, {
    String? keyword,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (keyword != null && keyword.isNotEmpty) {
        queryParams['keyword'] = keyword;
      }
      final response = await _services.get(
        '/options/subcategories/$categoryId',
        queryParameters: queryParams,
      );
      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de subcategorías vacía',
            details: 'data is null',
          ),
        );
      }
      final map = data is Map<String, dynamic> ? data : null;
      if (map == null) {
        return Left(
          UnknownException(
            'Formato de respuesta de subcategorías inválido',
            details: data.runtimeType.toString(),
          ),
        );
      }
      final model = SubcategoryResponseModel.fromJson(map);
      return Right(model);
    } catch (e) {
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'branches_subcategories');
      return Left(appException);
    }
  }

  /// POST /branch multipart: subcategory_id, name, address, latitude, longitude,
  /// phone_contacts (string), monday..sunday ("true"/"false"), start_time, end_time, logo (MultipartFile).
  @override
  Future<Either<AppException, String>> createBranch(
    CreateBranchParams params,
  ) async {
    try {
      final map = <String, dynamic>{
        'subcategory_id': params.subcategoryId,
        'name': params.name,
        'address': params.address,
        'latitude': params.latitude.toString(),
        'longitude': params.longitude.toString(),
        'phone_contacts': params.phoneContacts,
        'monday': params.monday.toString(),
        'tuesday': params.tuesday.toString(),
        'wednesday': params.wednesday.toString(),
        'thursday': params.thursday.toString(),
        'friday': params.friday.toString(),
        'saturday': params.saturday.toString(),
        'sunday': params.sunday.toString(),
        'start_time': params.startTime,
        'end_time': params.endTime,
      };
      if (params.logoPath != null &&
          params.logoPath!.isNotEmpty &&
          params.logoPath != 'placeholder') {
        map['logo'] = await MultipartFile.fromFile(
          params.logoPath!,
          filename: params.logoPath!.split('/').last,
        );
      }
      // No enviar campo logo si no hay archivo (evita que el servidor rechace part vacío).
      final formData = FormData.fromMap(map);

      final response = await _services.post(
        '/branch',
        data: formData,
        isFormData: true,
      );

      final data = response.data;
      if (data == null) {
        return Left(
          UnknownException(
            'Respuesta de creación de sucursal vacía',
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
      if (kDebugMode && e is DioException) {
        final res = e.response;
        debugPrint(
          '[branches_create] POST /branch failed: status=${res?.statusCode}, '
          'data=${res?.data}',
        );
      }
      final appException = ExceptionHandler.handleException(e);
      ExceptionHandler.logException(appException, tag: 'branches_create');
      return Left(appException);
    }
  }
}
