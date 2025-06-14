// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealFoodModel _$MealFoodModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'fdc_id',
      'description',
      'quantity',
      'protein_grams',
      'carb_grams',
      'fat_grams',
    ],
  );
  return MealFoodModel(
    fdcId: (json['fdc_id'] as num).toInt(),
    description: json['description'] as String,
    quantity: (json['quantity'] as num).toDouble(),
    proteinGrams: (json['protein_grams'] as num).toDouble(),
    carbGrams: (json['carb_grams'] as num).toDouble(),
    fatGrams: (json['fat_grams'] as num).toDouble(),
    error: json['error'] as String?,
  );
}

Map<String, dynamic> _$MealFoodModelToJson(MealFoodModel instance) =>
    <String, dynamic>{
      'fdc_id': instance.fdcId,
      'description': instance.description,
      'quantity': instance.quantity,
      'protein_grams': instance.proteinGrams,
      'carb_grams': instance.carbGrams,
      'fat_grams': instance.fatGrams,
      'error': instance.error,
    };
