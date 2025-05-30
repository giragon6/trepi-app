import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trepi_app/features/food_search/data/models/food_details_model.dart';
import 'package:trepi_app/features/food_search/data/repositories/food_repository_impl.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository _foodRepository = FoodRepository();

  FoodBloc({required this.foodRepository}): super(FoodInitialState()) {
    on<GetFoodDetailsEvent>(_onGetFoodDetails);
  }

  _onGetFoodDetails(
      GetFoodDetailsEvent event, Emitter<FoodState> emit) async {
    emit(FoodLoadingState());
    try {
      final foodDetails = await foodRepository.getFoodDetails(event.fdcId);
      if (foodDetails.error != null) {
        emit(FoodErrorState(foodDetails.error!));
      } else {
        emit(FoodLoadedState(foodDetails));
      }
    } catch (e) {
      emit(FoodErrorState(e.toString()));
    }
  }
}