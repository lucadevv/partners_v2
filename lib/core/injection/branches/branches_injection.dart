import 'package:get_it/get_it.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/features/branches/data/datasource/branches_datasource.dart';
import 'package:partners/features/branches/data/datasource/ntw/ntw_branches_datasource_impl.dart';
import 'package:partners/features/branches/data/repository/branches_repository_impl.dart';
import 'package:partners/features/branches/domain/repository/branches_repository.dart';
import 'package:partners/features/branches/domain/use_case/create_branch_usecase.dart';
import 'package:partners/features/branches/domain/use_case/get_branches_usecase.dart';
import 'package:partners/features/branches/domain/use_case/get_categories_usecase.dart';
import 'package:partners/features/branches/domain/use_case/get_subcategories_usecase.dart';
import 'package:partners/features/branches/presentation/cubit/create_branch_cubit.dart';
import 'package:partners/features/branches/presentation/cubit/branches_cubit.dart';

class BranchesInjection {
  final GetIt _getIt;

  BranchesInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    // Un datasource y un repositorio por feature (branches), con sus métodos.
    if (!_getIt.isRegistered<BranchesDatasource>()) {
      _getIt.registerLazySingleton<BranchesDatasource>(
        () => NtwBranchesDatasourceImpl(services: _getIt<ApiServices>()),
      );
    }
    if (!_getIt.isRegistered<BranchesRepository>()) {
      _getIt.registerLazySingleton<BranchesRepository>(
        () => BranchesRepositoryImpl(
          datasource: _getIt<BranchesDatasource>(),
        ),
      );
    }
    if (!_getIt.isRegistered<GetBranchesUsecase>()) {
      _getIt.registerLazySingleton<GetBranchesUsecase>(
        () => GetBranchesUsecase(
          repository: _getIt<BranchesRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<GetCategoriesUsecase>()) {
      _getIt.registerLazySingleton<GetCategoriesUsecase>(
        () => GetCategoriesUsecase(
          repository: _getIt<BranchesRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<GetSubcategoriesUsecase>()) {
      _getIt.registerLazySingleton<GetSubcategoriesUsecase>(
        () => GetSubcategoriesUsecase(
          repository: _getIt<BranchesRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<CreateBranchUseCase>()) {
      _getIt.registerLazySingleton<CreateBranchUseCase>(
        () => CreateBranchUseCase(repository: _getIt<BranchesRepository>()),
      );
    }
    if (!_getIt.isRegistered<CreateBranchCubit>()) {
      _getIt.registerFactory<CreateBranchCubit>(
        () => CreateBranchCubit(
          createBranchUseCase: _getIt<CreateBranchUseCase>(),
        ),
      );
    }
    if (!_getIt.isRegistered<BranchesCubit>()) {
      _getIt.registerFactory<BranchesCubit>(
        () => BranchesCubit(
          getBranchesUsecase: _getIt<GetBranchesUsecase>(),
        ),
      );
    }
  }
}
