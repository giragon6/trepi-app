// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealModel _$MealModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'name',
      'foods',
      'total_grams',
      'carb_grams',
      'fat_grams',
      'protein_grams',
      'nutrient_profile',
    ],
  );
  return MealModel(
    id: json['id'] as String,
    name: json['name'] as String,
    foods: (json['foods'] as List<dynamic>)
        .map((e) => MealFoodModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    totalGrams: (json['total_grams'] as num).toDouble(),
    carbGrams: (json['carb_grams'] as num).toDouble(),
    fatGrams: (json['fat_grams'] as num).toDouble(),
    proteinGrams: (json['protein_grams'] as num).toDouble(),
    nutrientProfile: (json['nutrient_profile'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
    ),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$MealModelToJson(MealModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'foods': instance.foods.map((e) => e.toJson()).toList(),
  'total_grams': instance.totalGrams,
  'carb_grams': instance.carbGrams,
  'fat_grams': instance.fatGrams,
  'protein_grams': instance.proteinGrams,
  'nutrient_profile': instance.nutrientProfile.map(
    (k, e) => MapEntry(k.toString(), e),
  ),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
