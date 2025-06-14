import 'package:trepi_app/features/meals/domain/entities/meal.dart';
import 'package:trepi_app/features/meals/domain/repositories/meal_repository.dart';
import 'package:trepi_app/utils/result.dart';

class GetMealDetails {
  final MealRepository _mealRepository;

  GetMealDetails(this._mealRepository);

  Future<Result<Meal>> call(String userId, String mealId) async {
    return await _mealRepository.getMealById(userId, mealId);
  }
}