import 'package:trepi_app/features/food_search/domain/entities/food_nutrient.dart';

class FoodDetails {
  final int fdcId;
  final String dataType;
  final String? itemDescription;
  final String? foodCategoryId;
  final String? brandOwner;
  final String? brandName;
  final String? gtinUpc;
  final String? ingredientsStr;
  final String? notASignificantSourceOf;
  final String? servingSize;
  final String? servingSizeUnit;
  final String? householdServing;
  final String? brandedFoodCategory;
  final List<FoodNutrient> nutrients;

  FoodDetails({
    required this.fdcId,
    required this.dataType,
    this.itemDescription,
    this.foodCategoryId,
    this.brandOwner,
    this.brandName,
    this.gtinUpc,
    this.ingredientsStr,
    this.notASignificantSourceOf,
    this.servingSize,
    this.servingSizeUnit,
    this.householdServing,
    this.brandedFoodCategory,
    required this.nutrients
  });
}