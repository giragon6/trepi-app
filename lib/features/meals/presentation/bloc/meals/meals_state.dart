part of 'meals_bloc.dart';

abstract class MealsState extends Equatable {
  const MealsState();

  @override
  List<Object?> get props => [];
}

class MealsInitialState extends MealsState {}

class MealsLoadingState extends MealsState {}

class MealsLoadedState extends MealsState {
  final List<Meal> meals;

  const MealsLoadedState(this.meals);

  @override
  List<Object?> get props => [meals];
}

class MealsErrorState extends MealsState {
  final String message;

  const MealsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}