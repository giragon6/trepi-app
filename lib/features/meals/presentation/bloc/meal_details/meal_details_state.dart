part of 'meal_details_bloc.dart';

abstract class MealDetailsState extends Equatable {
  const MealDetailsState();

  @override
  List<Object?> get props => [];
}

class MealDetailsInitialState extends MealDetailsState {}

class MealDetailsLoadingState extends MealDetailsState {}

class MealDetailsLoadedState extends MealDetailsState {
  final Meal meal;

  const MealDetailsLoadedState(this.meal);

  @override
  List<Object?> get props => [meal];
}

class MeaLDetailsDeletedState extends MealDetailsState {
  final String mealId;

  const MeaLDetailsDeletedState(this.mealId);

  @override
  List<Object?> get props => [mealId];
}

class MealDetailsErrorState extends MealDetailsState {
  final String error;

  const MealDetailsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}