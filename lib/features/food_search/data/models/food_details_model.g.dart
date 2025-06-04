// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodDetailsModel _$FoodDetailsModelFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['fdc_id', 'data_type']);
  return FoodDetailsModel(
    fdcId: (json['fdc_id'] as num).toInt(),
    dataType: json['data_type'] as String,
    itemDescription: json['item_description'] as String?,
    foodCategoryId: json['food_category_id'] as String?,
    brandOwner: json['brand_owner'] as String?,
    brandName: json['brand_name'] as String?,
    gtinUpc: json['gtin_upc'] as String?,
    ingredientsStr: json['ingredients_str'] as String?,
    notASignificantSourceOf: json['not_a_significant_source_of'] as String?,
    servingSize: json['serving_size'] as String?,
    servingSizeUnit: json['serving_size_unit'] as String?,
    householdServing: json['household_serving'] as String?,
    brandedFoodCategory: json['branded_food_category'] as String?,
    nutrients: (json['nutrients'] as List<dynamic>)
        .map((e) => FoodNutrientModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  )..error = json['error'] as String?;
}

Map<String, dynamic> _$FoodDetailsModelToJson(FoodDetailsModel instance) =>
    <String, dynamic>{
      'fdc_id': instance.fdcId,
      'data_type': instance.dataType,
      'item_description': instance.itemDescription,
      'food_category_id': instance.foodCategoryId,
      'brand_owner': instance.brandOwner,
      'brand_name': instance.brandName,
      'gtin_upc': instance.gtinUpc,
      'ingredients_str': instance.ingredientsStr,
      'not_a_significant_source_of': instance.notASignificantSourceOf,
      'serving_size': instance.servingSize,
      'serving_size_unit': instance.servingSizeUnit,
      'household_serving': instance.householdServing,
      'branded_food_category': instance.brandedFoodCategory,
      'nutrients': instance.nutrients.map((e) => e.toJson()).toList(),
      'error': instance.error,
    };
