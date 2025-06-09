import 'package:get_it/get_it.dart';
import 'package:trepi_app/core/config/app_config.dart';
import 'package:trepi_app/core/network/api_client.dart';
import 'package:trepi_app/features/food_search/data/datasources/food_data_source.dart';
import 'package:trepi_app/features/food_search/data/repositories/food_repository_impl.dart';
import 'package:trepi_app/features/food_search/domain/repositories/food_repository.dart';
import 'package:trepi_app/features/food_search/domain/usecases/request_food.dart';
import 'package:trepi_app/features/food_search/domain/usecases/search_food.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_details/food_details_bloc.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_search/food_search_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: AppConfig.apiBaseUrl),
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

  getIt.registerFactory<FoodDetailsBloc>(
    () => FoodDetailsBloc(requestFoodDetails: getIt<RequestFood>()),
  );

  getIt.registerLazySingleton<SearchFood>(
    () => SearchFood(getIt<FoodRepository>()),
  );

  getIt.registerFactory<FoodSearchBloc>(
    () => FoodSearchBloc(searchFood: getIt<SearchFood>()),
  );
}