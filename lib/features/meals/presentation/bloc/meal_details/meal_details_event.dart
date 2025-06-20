part of 'meal_details_bloc.dart';

sealed class MealDetailsEvent extends Equatable {
  const MealDetailsEvent();

  @override
  List<Object?> get props => [];
} 

class GetMealDetailsEvent extends MealDetailsEvent {
  final String userId;
  final String mealId;

  const GetMealDetailsEvent(this.userId, this.mealId);

  @override
  List<Object?> get props => [userId, mealId];
}

class UpdateMealDetailsEvent extends MealDetailsEvent {
  final String userId;
  final Meal meal;

  const UpdateMealDetailsEvent(this.userId, this.meal);

  @override
  List<Object?> get props => [userId, meal];
}