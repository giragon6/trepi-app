import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
import 'package:trepi_app/features/food_search/domain/usecases/request_food.dart';
import 'package:trepi_app/utils/result.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final RequestFood _requestFood;

  FoodBloc({required RequestFood requestFood}) 
    : _requestFood = requestFood, 
      super(FoodInitialState()) {
    on<GetFoodDetailsEvent>(_onGetFoodDetails);
  }

  Future<void> _onGetFoodDetails(
      GetFoodDetailsEvent event, 
      Emitter<FoodState> emit
    ) async {
    emit(FoodLoadingState());
    final result = await _requestFood.getFoodDetails(event.fdcId);
    try {

      switch(result) {
        case Ok<FoodDetails>(): {
          emit(FoodLoadedState(result.value));
        }
        case Error<FoodDetails>(): {
          emit(FoodErrorState(result.error.toString()));
        }
      };
    } catch (e) {
      emit(FoodErrorState(e.toString()));
    }
  }
}