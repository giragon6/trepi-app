part of 'food_search_bloc.dart';

abstract class FoodSearchState extends Equatable {
  const FoodSearchState();

  @override
  List<Object?> get props => [];
}

class FoodSearchInitialState extends FoodSearchState {}

class FoodSearchLoadingState extends FoodSearchState {}

class FoodSearchLoadedState extends FoodSearchState {
  final List<FoodSearchResult> foodResults;
  
  const FoodSearchLoadedState(this.foodResults);
}

class FoodSearchErrorState extends FoodSearchState {
  final String error;

  const FoodSearchErrorState(this.error);

  @override
  List<Object?> get props => [error];
}