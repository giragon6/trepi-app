part of 'food_details_bloc.dart';

abstract class FoodDetailsEvent extends Equatable {
  const FoodDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetFoodDetailsEvent extends FoodDetailsEvent {
  final int fdcId;
  
  const GetFoodDetailsEvent(this.fdcId);
  
  @override
  List<Object?> get props => [fdcId];
}