part of 'food_details_bloc.dart';

abstract class FoodDetailsState extends Equatable {
  const FoodDetailsState();

  @override
  List<Object?> get props => [];
}

class FoodDetailsInitialState extends FoodDetailsState {}

class FoodDetailsLoadingState extends FoodDetailsState {}

class FoodDetailsLoadedState extends FoodDetailsState {
  final FoodDetails foodDetails;
  
  const FoodDetailsLoadedState(this.foodDetails);
}

class FoodDetailsErrorState extends FoodDetailsState {
  final String error;

  const FoodDetailsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}