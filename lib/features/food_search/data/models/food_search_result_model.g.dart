// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodSearchResultModel _$FoodSearchResultModelFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, requiredKeys: const ['fdc_id', 'item_description']);
  return FoodSearchResultModel(
    fdcId: (json['fdc_id'] as num).toInt(),
    dataType: json['data_type'] as String?,
    itemDescription: json['item_description'] as String,
  );
}

Map<String, dynamic> _$FoodSearchResultModelToJson(
  FoodSearchResultModel instance,
) => <String, dynamic>{
  'fdc_id': instance.fdcId,
  'data_type': instance.dataType,
  'item_description': instance.itemDescription,
};
