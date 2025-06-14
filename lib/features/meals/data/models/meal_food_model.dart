import 'package:json_annotation/json_annotation.dart';
import 'package:trepi_app/features/meals/domain/entities/meal_food.dart';

part 'meal_food_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MealFoodModel extends MealFood {
  MealFoodModel({
    required this.fdcId,
    required this.description,
    required this.quantity,
    required this.proteinGrams,
    required this.carbGrams,
    required this.fatGrams,
    this.error
  }) : super(
          fdcId: fdcId,
          description: description,
          quantity: quantity,
          proteinGrams: proteinGrams,
          carbGrams: carbGrams,
          fatGrams: fatGrams,
          error: error,
        );

  @JsonKey(required: true)
  final int fdcId;

  @JsonKey(required: true)
  final String description;

  @JsonKey(required: true)
  final double quantity; 

  @JsonKey(required: true)
  final double proteinGrams;

  @JsonKey(required: true)
  final double carbGrams;

  @JsonKey(required: true)
  final double fatGrams;

  String? error;

  MealFoodModel.withError(String errorMessage)
    : fdcId = -1,
      description = '',
      quantity = 0.0,
      proteinGrams = 0.0,
      carbGrams = 0.0,
      fatGrams = 0.0,
      error = errorMessage,
      super(
        fdcId: -1, 
        description: '',
        quantity: 0.0,
        proteinGrams: 0.0,
        carbGrams: 0.0,
        fatGrams: 0.0,
        error: errorMessage,
      );

  factory MealFoodModel.fromJson(Map<String, dynamic> json) =>
      _$MealFoodModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MealFoodModelToJson(this);
}