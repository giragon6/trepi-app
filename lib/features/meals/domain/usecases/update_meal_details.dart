import 'package:trepi_app/features/meals/domain/entities/meal.dart';
import 'package:trepi_app/features/meals/domain/repositories/meal_repository.dart';
import 'package:trepi_app/utils/result.dart';

class UpdateMealDetails {
  final MealRepository _mealRepository;

  UpdateMealDetails(this._mealRepository);

  Future<Result<void>> call(String userId, Meal meal) async {
    return await _mealRepository.updateMeal(userId, meal);
  }
}