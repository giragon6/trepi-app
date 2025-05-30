import 'package:json_annotation/json_annotation.dart';
import 'package:trepi_app/features/food_search/domain/entities/food.dart';

part 'food_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FoodModel extends Food {
  FoodModel({
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
    this.createdAt,
    this.updatedAt,
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
          createdAt: createdAt,
          updatedAt: updatedAt
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
  DateTime? createdAt;
  DateTime? updatedAt;

  String? error;

  FoodModel.withError(String errorMessage) 
  :   fdcId = -1,
      dataType = '',
      error = errorMessage, 
    super( 
      fdcId: -1,
      dataType: ''
    );

  factory FoodModel.fromJson(Map<String, dynamic> json) =>
      _$FoodModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodModelToJson(this);
}