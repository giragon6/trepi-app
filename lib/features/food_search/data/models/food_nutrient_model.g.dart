// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_nutrient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodNutrientModel _$FoodNutrientModelFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['nutrient_id', 'amount']);
  return FoodNutrientModel(
    nutrientId: (json['nutrient_id'] as num).toInt(),
    amount: (json['amount'] as num).toDouble(),
    derivationId: (json['derivation_id'] as num?)?.toInt(),
    percentDailyValue: (json['percent_daily_value'] as num?)?.toDouble(),
    footnote: json['footnote'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    error: json['error'] as String?,
  );
}

Map<String, dynamic> _$FoodNutrientModelToJson(FoodNutrientModel instance) =>
    <String, dynamic>{
      'nutrient_id': instance.nutrientId,
      'amount': instance.amount,
      'derivation_id': instance.derivationId,
      'footnote': instance.footnote,
      'percent_daily_value': instance.percentDailyValue,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'error': instance.error,
    };
