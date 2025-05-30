import 'package:json_annotation/json_annotation.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_nutrient.dart';

part 'nutrient_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FoodNutrientModel extends FoodNutrient {
  FoodNutrientModel({
    required this.nutrientId,
    required this.amount,
    this.derivationId,
    this.percentDailyValue,
    this.footnote,
    this.createdAt,
    this.updatedAt,
    this.error,
  }) : super(
          nutrientId: nutrientId,
          amount: amount,
          derivationId: derivationId,
          percentDailyValue: percentDailyValue,
          footnote: footnote,
          createdAt: createdAt,
          updatedAt: updatedAt,
  );

  @JsonKey(required: true, includeFromJson: false, includeToJson: false)
  int? foodNutrientId;

  @JsonKey(required: true, includeFromJson: false, includeToJson: false)
  int? foodId;

  @JsonKey(required: true)
  final int nutrientId;

  @JsonKey(required: true)
  final double amount;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? dataPoints;
  int? derivationId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? min;
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? max;
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? median;
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? loq;

  String? footnote;
  double? percentDailyValue;
  DateTime? createdAt;
  DateTime? updatedAt;

  String? error;

  FoodNutrientModel.withError(String errorMessage) :
    nutrientId = -1,
    amount = -1.0,
    derivationId = null,
    percentDailyValue = null,
    error = errorMessage,
    dataPoints = null,
    min = null,
    max = null,
    median = null,
    loq = null,
    footnote = null,
    createdAt = null,
    updatedAt = null,
    super(
      nutrientId: -1,
      amount: -1.0,
      derivationId: null,
      percentDailyValue: null,
      dataPoints: null,
      footnote: null,
      createdAt: null,
      updatedAt: null,
    );
  

  factory FoodNutrientModel.fromJson(Map<String, dynamic> json) =>
      _$FoodNutrientModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodNutrientModelToJson(this);
}