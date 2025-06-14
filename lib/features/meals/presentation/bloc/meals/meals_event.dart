part of 'meals_bloc.dart';

abstract class MealsEvent extends Equatable {
  const MealsEvent();

  @override
  List<Object?> get props => [];
}

class GetMealsEvent extends MealsEvent {
  final String userId;

  const GetMealsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddMealEvent extends MealsEvent {
  final String userId;
  final Meal meal;

  const AddMealEvent(this.userId, this.meal);

  @override
  List<Object?> get props => [userId, meal];
}

class DeleteMealEvent extends MealsEvent {
  final String userId;
  final String mealId;

  const DeleteMealEvent(this.userId, this.mealId);

  @override
  List<Object?> get props => [userId, mealId];
}