part of 'food_search_bloc.dart';

abstract class FoodSearchEvent extends Equatable {
  const FoodSearchEvent();

  @override
  List<Object?> get props => [];
}

class GetFoodSearchEvent extends FoodSearchEvent {
  final String name;
  
  const GetFoodSearchEvent(this.name);
  
  @override
  List<Object?> get props => [name];
}