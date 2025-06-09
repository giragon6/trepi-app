import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
import 'package:trepi_app/features/food_search/domain/usecases/request_food.dart';
import 'package:trepi_app/utils/result.dart';

part 'food_details_event.dart';
part 'food_details_state.dart';

class FoodDetailsBloc extends Bloc<FoodDetailsEvent, FoodDetailsState> {
  final RequestFood _requestFoodDetails;

  FoodDetailsBloc({required RequestFood requestFoodDetails}) 
    : _requestFoodDetails = requestFoodDetails, 
      super(FoodDetailsInitialState()) {
    on<GetFoodDetailsEvent>(_onGetFoodDetails);
  }

  Future<void> _onGetFoodDetails(
      GetFoodDetailsEvent event, 
      Emitter<FoodDetailsState> emit
    ) async {
    emit(FoodDetailsLoadingState());
    final result = await _requestFoodDetails.getFoodDetails(event.fdcId);
    try {

      switch(result) {
        case Ok<FoodDetails>(): {
          emit(FoodDetailsLoadedState(result.value));
        }
        case Error<FoodDetails>(): {
          emit(FoodDetailsErrorState(result.error.toString()));
        }
      };
    } catch (e) {
      emit(FoodDetailsErrorState(e.toString()));
    }
  }
}