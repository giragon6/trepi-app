import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
import 'package:trepi_app/utils/result.dart';

Result<double> getNutrientAmount(int nutrientId, FoodDetails foodDetails) {
  try {
    final nutrient = foodDetails.nutrients
        .firstWhere((nutrient) => nutrient.nutrientId == nutrientId);
    return Result.ok(nutrient.amount);
  } catch (e) {
    return Result.error(
      Exception('Nutrient with ID $nutrientId not found in food details.')
    ); 
  }
}