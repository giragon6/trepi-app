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
  final bool isFirstPage;
  final bool isLastPage;
  final int pageSize;
  final int pageNumber;
  
  const FoodSearchLoadedState(this.foodResults, this.isFirstPage, this.isLastPage, this.pageSize, this.pageNumber);
  
  @override
  List<Object?> get props => [foodResults, isLastPage, pageSize, pageNumber];
}

class FoodSearchErrorState extends FoodSearchState {
  final String error;

  const FoodSearchErrorState(this.error);

  @override
  List<Object?> get props => [error];
}