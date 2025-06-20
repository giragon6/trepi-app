import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trepi_app/features/meals/data/models/meal_food_model.dart';
import 'package:trepi_app/features/meals/data/models/meal_model.dart';
import 'package:trepi_app/features/meals/domain/entities/meal.dart';
import 'package:trepi_app/utils/result.dart';

class MealDataSource {
  final FirebaseFirestore _firestore;

  MealDataSource(this._firestore);

Future<Result<void>> addMeal(String userId, Meal meal) async {
    final mealCollection = _firestore.collection('users').doc(userId).collection('meals');
    try {
      await mealCollection.doc().set({
        'name': meal.name,
        'foods': meal.foods.map((food) => MealFoodModel(
          fdcId: food.fdcId, 
          description: food.description, 
          quantity: food.quantity, 
          carbGrams: food.carbGrams, 
          proteinGrams: food.proteinGrams, 
          fatGrams: food.fatGrams,
        ).toJson()).toList(),
        'totalGrams': meal.totalGrams,
        'carbGrams': meal.carbGrams,
        'fatGrams': meal.fatGrams,
        'proteinGrams': meal.proteinGrams,
        'nutrientProfile': meal.nutrientProfile,
        'createdAt': meal.createdAt ?? FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Failed to add meal: $e'));
    }
  }
  
  Future<Result<void>> updateMeal(String userId, Meal meal) async {
    final mealCollection = _firestore.collection('users').doc(userId).collection('meals');
    try {
      await mealCollection.doc(meal.id).update({
        'name': meal.name,
        'foods': meal.foods.map((food) => MealFoodModel(
          fdcId: food.fdcId, 
          description: food.description, 
          quantity: food.quantity, 
          carbGrams: food.carbGrams, 
          proteinGrams: food.proteinGrams, 
          fatGrams: food.fatGrams,
        ).toJson()).toList(),
        'totalGrams': meal.totalGrams,
        'carbGrams': meal.carbGrams,
        'fatGrams': meal.fatGrams,
        'proteinGrams': meal.proteinGrams,
        'nutrientProfile': meal.nutrientProfile,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Failed to update meal: $e'));
    }
  }

  Future<Result<void>> deleteMeal(String userId, String mealId) async {
    final mealCollection = _firestore.collection('users').doc(userId).collection('meals');
    try {
      await mealCollection.doc(mealId).delete();
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Failed to delete meal: $e'));
    }
  }

  Future<Result<List<Meal>>> getMeals(String userId) async {
    final mealCollection = _firestore.collection('users').doc(userId).collection('meals');
    try {
      final snapshot = await mealCollection.get();
      final meals = snapshot.docs.map((doc) {
        final data = doc.data();
        return MealModel.fromJson(doc.id, data);
      }).toList();
      return Result.ok(meals);
    } catch (e) {
      return Result.error(Exception('Failed to fetch meals: $e'));
    }
  }

  Future<Result<Meal>> getMealById(String userId, String mealId) async {
    final mealCollection = _firestore.collection('users').doc(userId).collection('meals');
    try {
      final doc = await mealCollection.doc(mealId).get();
      if (!doc.exists) {
        return Result.error(Exception('Meal not found'));
      }
      final data = doc.data()!;
      final meal = Meal(
        id: doc.id,
        name: data['name'] as String,
        foods: (data['foods'] as List<dynamic>?)
            ?.map((food) => MealFoodModel.fromJson(food as Map<String, dynamic>))
            .toList() ?? [],
        totalGrams: (data['totalGrams'] as num).toDouble(),
        carbGrams: (data['carbGrams'] as num).toDouble(),
        fatGrams: (data['fatGrams'] as num).toDouble(),
        proteinGrams: (data['proteinGrams'] as num).toDouble(),
        nutrientProfile: Map<int, double>.from(data['nutrientProfile']),
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      );
      return Result.ok(meal);
    } catch (e) {
      return Result.error(Exception('Failed to fetch meal by ID: $e'));
    }
  }}  