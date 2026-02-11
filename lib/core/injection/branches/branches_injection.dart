import 'package:get_it/get_it.dart';
import 'package:partners/features/branches/data/datasource/branches_datasource.dart';
import 'package:partners/features/branches/data/datasource/provider_memory/mock_branches_datasource_impl.dart';
import 'package:partners/features/branches/data/repository/branches_repository_impl.dart';
import 'package:partners/features/branches/domain/repository/branches_repository.dart';
import 'package:partners/features/branches/domain/use_case/get_branches_usecase.dart';
import 'package:partners/features/branches/presentation/cubit/branches_cubit.dart';

class BranchesInjection {
  final GetIt _getIt;

  BranchesInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    // Datasource
    if (!_getIt.isRegistered<BranchesDatasource>()) {
      _getIt.registerLazySingleton<BranchesDatasource>(
        () => MockBranchesDatasourceImpl(),
      );
    }

    // Repository
    if (!_getIt.isRegistered<BranchesRepository>()) {
      _getIt.registerLazySingleton<BranchesRepository>(
        () => BranchesRepositoryImpl(
          datasource: _getIt<BranchesDatasource>(),
        ),
      );
    }

    // Use Case
    if (!_getIt.isRegistered<GetBranchesUsecase>()) {
      _getIt.registerLazySingleton<GetBranchesUsecase>(
        () => GetBranchesUsecase(
          repository: _getIt<BranchesRepository>(),
        ),
      );
    }

    // Cubit
    if (!_getIt.isRegistered<BranchesCubit>()) {
      _getIt.registerFactory<BranchesCubit>(
        () => BranchesCubit(
          getBranchesUsecase: _getIt<GetBranchesUsecase>(),
        ),
      );
    }
  }
}
