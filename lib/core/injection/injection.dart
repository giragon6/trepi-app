import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:trepi_app/core/config/app_config.dart';
import 'package:trepi_app/core/network/api_client.dart';
import 'package:trepi_app/features/authentication/data/datasources/authentication_data_source.dart';
import 'package:trepi_app/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:trepi_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth_form/auth_form_bloc.dart';
import 'package:trepi_app/features/food_search/data/datasources/food_data_source.dart';
import 'package:trepi_app/features/food_search/data/repositories/food_repository_impl.dart';
import 'package:trepi_app/features/food_search/domain/repositories/food_repository.dart';
import 'package:trepi_app/features/food_search/domain/usecases/request_food.dart';
import 'package:trepi_app/features/food_search/domain/usecases/search_food.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_details/food_details_bloc.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_search/food_search_bloc.dart';
import 'package:trepi_app/features/meals/data/datasources/meal_datasource.dart';
import 'package:trepi_app/features/meals/data/repositories/meal_repository_impl.dart';
import 'package:trepi_app/features/meals/domain/repositories/meal_repository.dart';
import 'package:trepi_app/features/meals/domain/usecases/get_meal_details.dart';
import 'package:trepi_app/features/meals/domain/usecases/update_meal_details.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meal_details/meal_details_bloc.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meals/meals_bloc.dart';

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

  getIt.registerLazySingleton<AppConfig>(
    () => AppConfig(),
  );

  getIt.registerLazySingleton<FormBloc>(
    () => FormBloc(getIt<AuthenticationRepository>()),
  );
  
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(getIt<AuthenticationDataSource>()),
  );

  getIt.registerLazySingleton<AuthenticationDataSource>(
    () => AuthenticationDataSource(),
  );

  getIt.registerLazySingleton<AuthenticationBloc>(
    () => AuthenticationBloc(
      getIt<AuthenticationRepository>(),
    )
  );

  getIt.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(getIt<MealDataSource>()),
  );

  getIt.registerLazySingleton<MealsBloc>(
    () => MealsBloc(getIt<MealRepository>()),
  );

  getIt.registerLazySingleton<MealDataSource>(
    () => MealDataSource(FirebaseFirestore.instance),
  );

  getIt.registerLazySingleton<GetMealDetails>(
    () => GetMealDetails(getIt<MealRepository>()),
  );

  getIt.registerLazySingleton<UpdateMealDetails>(
    () => UpdateMealDetails(getIt<MealRepository>()),
  );

  getIt.registerLazySingleton<MealDetailsBloc>(
    () => MealDetailsBloc(getMealDetails: getIt<GetMealDetails>(), updateMealDetails: getIt<UpdateMealDetails>()),
  );

}