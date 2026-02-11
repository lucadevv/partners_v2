import 'package:get_it/get_it.dart';
import 'package:partners/features/users/data/data.dart';
import 'package:partners/features/users/domain/domain.dart';

class UsersInjection {
  final GetIt _getIt;

  UsersInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    if (!_getIt.isRegistered<UsersMapDatasource>()) {
      _getIt.registerLazySingleton<UsersMapDatasource>(
        () => MockUsersMapDatasourceImpl(),
      );
    }

    if (!_getIt.isRegistered<UsersMapRepository>()) {
      _getIt.registerLazySingleton<UsersMapRepository>(
        () => UsersMapRepositoryImpl(
          datasource: _getIt<UsersMapDatasource>(),
        ),
      );
    }

    if (!_getIt.isRegistered<GetUsersInRadiusUsecase>()) {
      _getIt.registerLazySingleton<GetUsersInRadiusUsecase>(
        () => GetUsersInRadiusUsecase(
          repository: _getIt<UsersMapRepository>(),
        ),
      );
    }
  }
}
