import 'package:get_it/get_it.dart';
import 'package:trepi_app/core/network/api_client.dart';
import 'package:trepi_app/features/food_search/data/datasources/food_data_source.dart';
import 'package:trepi_app/features/food_search/data/repositories/food_repository_impl.dart';
import 'package:trepi_app/features/food_search/domain/repositories/food_repository.dart';
import 'package:trepi_app/features/food_search/domain/usecases/request_food.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: const String.fromEnvironment(
        'BASE_URL',
        defaultValue: 'http://localhost:8000/api/v1',
      ),
    ),
  );

  getIt.registerLazySingleton<FoodDataSource>(
    () => FoodDataSource(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<FoodRepository>(
    () => FoodRepositoryImpl(getIt<FoodDataSource>()),
  );

  getIt.registerLazySingleton<RequestFood>(
    () => RequestFood(getIt<FoodRepository>()),
  );

  getIt.registerFactory<FoodBloc>(
    () => FoodBloc(requestFood: getIt<RequestFood>()),
  );
}