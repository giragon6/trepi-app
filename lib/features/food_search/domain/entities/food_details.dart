import 'package:trepi_app/features/food_search/domain/entities/food.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_nutrient.dart';

class FoodDetails {
  final Food food;
  final List<FoodNutrient> nutrients;

  FoodDetails({
    required this.food,
    required this.nutrients,
  });
}