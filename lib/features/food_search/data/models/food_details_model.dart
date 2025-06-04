import 'package:trepi_app/features/food_search/data/models/food_nutrient_model.dart';
import 'package:trepi_app/features/food_search/data/models/food_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';

part 'food_details_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class FoodDetailsModel extends FoodDetails {
  FoodDetailsModel({
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
  }) : super(
          fdcId: fdcId,
          dataType: dataType,
          itemDescription: itemDescription,
          foodCategoryId: foodCategoryId,
          brandOwner: brandOwner,
          brandName: brandName,
          gtinUpc: gtinUpc,
          ingredientsStr: ingredientsStr,
          notASignificantSourceOf: notASignificantSourceOf,
          servingSize: servingSize,
          servingSizeUnit: servingSizeUnit,
          householdServing: householdServing,
          brandedFoodCategory: brandedFoodCategory,
          nutrients: nutrients,
        );

  @override
  @JsonKey(required: true)
  final int fdcId;

  @JsonKey(required: true)
  final String dataType;

  String? itemDescription;
  String? foodCategoryId;
  String? brandOwner;
  String? brandName;
  String? gtinUpc;
  String? ingredientsStr;
  String? notASignificantSourceOf;
  String? servingSize;
  String? servingSizeUnit;
  String? householdServing;
  String? brandedFoodCategory;

  final List<FoodNutrientModel> nutrients;
  String? error;

  FoodDetailsModel.withError(String errorMessage) 
  : fdcId = -1,
    dataType = '',
    nutrients = [],
    error = errorMessage, 
    super(
      fdcId: -1,
      dataType: '',
      nutrients: [],
    );

  factory FoodDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$FoodDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodDetailsModelToJson(this);
}