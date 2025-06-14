import 'package:json_annotation/json_annotation.dart';
import 'package:trepi_app/features/meals/domain/entities/meal_food.dart';

part 'meal_food_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MealFoodModel extends MealFood {
  MealFoodModel({
    required this.fdcId,
    required this.description,
    this.error
  }) : super(
          fdcId: fdcId,
          description: description,
          error: error,
        );

  @JsonKey(required: true)
  final String fdcId;

  @JsonKey(required: true)
  final String description;

  String? error;

  MealFoodModel.withError(String errorMessage)
    : fdcId = '',
      description = '',
      error = errorMessage,
      super(
        fdcId: '', 
        description: '',
        error: errorMessage,
      );

  factory MealFoodModel.fromJson(Map<String, dynamic> json) =>
      _$MealFoodModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealFoodModelToJson(this);
}