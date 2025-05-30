import 'package:trepi_app/features/food_search/data/models/food_nutrient_model.dart';
import 'package:trepi_app/features/food_search/data/models/food_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';

part '../model/food_details_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class FoodDetailsModel extends FoodDetails {
  FoodDetailsModel({
    required this.food,
    required this.nutrients
  }) : super(
          food: food,
          nutrients: nutrients,
        );

  final FoodModel food;
  final List<FoodNutrientModel> nutrients;
  String? error;

  FoodDetailsModel.withError(String errorMessage) 
  : food = FoodModel(fdcId: -1, dataType: ''),
    nutrients = [],
  super (
    food: FoodModel(fdcId: -1, dataType: ''),
    nutrients: [],
  );

  factory FoodDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$FoodDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodDetailsModelToJson(this);
}