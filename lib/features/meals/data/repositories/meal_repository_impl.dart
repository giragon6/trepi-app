import 'package:trepi_app/features/meals/data/datasources/meal_datasource.dart';
import 'package:trepi_app/features/meals/domain/entities/meal.dart';
import 'package:trepi_app/features/meals/domain/repositories/meal_repository.dart';
import 'package:trepi_app/utils/result.dart';

class MealRepositoryImpl extends MealRepository {
  MealDataSource _dataSource;

  MealRepositoryImpl(MealDataSource dataSource) : _dataSource = dataSource;

  Future<Result<void>> addMeal(String userId, Meal meal) async {
    return _dataSource.addMeal(userId, meal);
  }

  Future<Result<void>> updateMeal(String userId, Meal meal) async {
    return _dataSource.updateMeal(userId, meal);
  }

  Future<Result<void>> deleteMeal(String userId, String mealId) async {
    return _dataSource.deleteMeal(userId, mealId);
  }

  Future<Result<List<Meal>>> getMeals(String userId) async {
    return _dataSource.getMeals(userId);
  }

  Future<Result<Meal>> getMealById(String userId, String mealId) async {
    return _dataSource.getMealById(userId, mealId);
  }
}