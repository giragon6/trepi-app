import 'package:equatable/equatable.dart';
import 'package:trepi_app/features/meals/domain/entities/meal_food.dart';

class Meal extends Equatable {
  final String id;
  String name;
  List<MealFood> foods;
  double totalGrams;
  double carbGrams;
  double fatGrams;
  double proteinGrams;
  Map<int, double> nutrientProfile;
  final DateTime? createdAt;
  DateTime? updatedAt;

  Meal({
    required this.id,
    required this.name,
    required this.foods,
    required this.totalGrams,
    required this.carbGrams,
    required this.fatGrams,
    required this.proteinGrams,
    required this.nutrientProfile,
    this.createdAt,
    this.updatedAt
  });

  @override
  List<Object?> get props => [
        id,
        name,
        foods,
        totalGrams,
        carbGrams,
        fatGrams,
        proteinGrams,
        nutrientProfile,
        createdAt,
        updatedAt
      ];
}