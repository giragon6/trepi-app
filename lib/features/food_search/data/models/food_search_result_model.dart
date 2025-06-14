import 'package:json_annotation/json_annotation.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_search_result.dart';

part 'food_search_result_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FoodSearchResultModel extends FoodSearchResult {
  @JsonKey(required: true)
  final int fdcId;
  final String? dataType;
  @JsonKey(required: true)
  final String itemDescription;

  FoodSearchResultModel({
    required this.fdcId,
    this.dataType,
    required this.itemDescription,
  }) : super(
          fdcId: fdcId,
          dataType: dataType,
          itemDescription: itemDescription,
        );

  FoodSearchResultModel.withError(String errorMessage)
      : fdcId = -1,
        dataType = null,
        itemDescription = errorMessage,
        super(fdcId: -1, dataType: null, itemDescription: errorMessage);

  factory FoodSearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$FoodSearchResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodSearchResultModelToJson(this);
}