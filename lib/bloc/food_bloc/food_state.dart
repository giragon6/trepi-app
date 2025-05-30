part of 'food_bloc.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object?> get props => [];
}

class FoodInitialState extends FoodState {}

class FoodLoadingState extends FoodState {}

class FoodLoadedState extends FoodState {
  final FoodDetailsModel foodDetails;
  const FoodLoadedState(this.foodDetails);
}

class FoodErrorState extends FoodState {
  final String error;
  const FoodErrorState(this.error);

  @override
  List<Object?> get props => [error];
}