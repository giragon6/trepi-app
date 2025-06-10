part of 'food_search_bloc.dart';

abstract class FoodSearchEvent extends Equatable {
  const FoodSearchEvent();

  @override
  List<Object?> get props => [];
}

class GetFoodSearchEvent extends FoodSearchEvent {
  final String name;
  final int pageSize;
  final int pageNumber;
  
  const GetFoodSearchEvent(this.name, this.pageSize, this.pageNumber);
  
  @override
  List<Object?> get props => [name];
}