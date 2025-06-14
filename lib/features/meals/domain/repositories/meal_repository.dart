import 'package:trepi_app/features/meals/domain/entities/meal.dart';
import 'package:trepi_app/utils/result.dart';

abstract class MealRepository {
  Future<Result<void>> addMeal(String userId, Meal meal);
  Future<Result<void>> updateMeal(String userId, Meal meal);
  Future<Result<void>> deleteMeal(String userId, String mealId);
  Future<Result<List<Meal>>> getMeals(String userId);
  Future<Result<Meal>> getMealById(String userId, String mealId);
}