// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealFoodModel _$MealFoodModelFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['fdc_id', 'description']);
  return MealFoodModel(
    fdcId: json['fdc_id'] as String,
    description: json['description'] as String,
    error: json['error'] as String?,
  );
}

Map<String, dynamic> _$MealFoodModelToJson(MealFoodModel instance) =>
    <String, dynamic>{
      'fdc_id': instance.fdcId,
      'description': instance.description,
      'error': instance.error,
    };
