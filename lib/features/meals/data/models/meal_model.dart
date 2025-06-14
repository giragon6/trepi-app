import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trepi_app/features/meals/data/models/meal_food_model.dart';
import 'package:trepi_app/features/meals/domain/entities/meal.dart';

part 'meal_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MealModel extends Meal {
  MealModel({
    required this.id,
    required this.name,
    required this.foods,
    required this.totalGrams,
    required this.carbGrams,
    required this.fatGrams,
    required this.proteinGrams,
    required this.nutrientProfile,
    this.createdAt,
    this.updatedAt,
  }) : super(
          id: id,
          name: name,
          foods: foods,
          totalGrams: totalGrams,
          carbGrams: carbGrams,
          fatGrams: fatGrams,
          proteinGrams: proteinGrams,
          nutrientProfile: nutrientProfile,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
  
  @override

  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final List<MealFoodModel> foods; 

  @JsonKey(required: true)
  final double totalGrams;

  @JsonKey(required: true)
  final double carbGrams;

  @JsonKey(required: true)
  final double fatGrams;

  @JsonKey(required: true)
  final double proteinGrams;

  @JsonKey(required: true)
  final Map<int, double> nutrientProfile;

  final DateTime? createdAt;
  DateTime? updatedAt;

  MealModel.withError(String errorMessage)
  : id = '',
    name = '',
    foods = [],
    totalGrams = 0.0,
    carbGrams = 0.0,
    fatGrams = 0.0,
    proteinGrams = 0.0,
    nutrientProfile = {},
    createdAt = DateTime.now(),
    updatedAt = DateTime.now(),
    super(
      id: '',
      name: '',
      foods: [],
      totalGrams: 0.0,
      carbGrams: 0.0,
      fatGrams: 0.0,
      proteinGrams: 0.0,
      nutrientProfile: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  
  factory MealModel.fromJson(String docId, Map<String, dynamic> data) {
    return MealModel(
      id: docId,
      name: data['name'] as String,
      foods: (data['foods'] as List<dynamic>?)
          ?.map((food) => MealFoodModel.fromJson(food as Map<String, dynamic>))
          .toList() ?? [],
      totalGrams: (data['totalGrams'] as num).toDouble(),
      carbGrams: (data['carbGrams'] as num).toDouble(),
      fatGrams: (data['fatGrams'] as num).toDouble(),
      proteinGrams: (data['proteinGrams'] as num).toDouble(),
      nutrientProfile: (data['nutrientProfile'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() => _$MealModelToJson(this);

}