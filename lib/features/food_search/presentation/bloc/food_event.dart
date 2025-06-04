part of 'food_bloc.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object?> get props => [];
}

class GetFoodDetailsEvent extends FoodEvent {
  final int fdcId;
  
  const GetFoodDetailsEvent(this.fdcId);
  
  @override
  List<Object?> get props => [fdcId];
}