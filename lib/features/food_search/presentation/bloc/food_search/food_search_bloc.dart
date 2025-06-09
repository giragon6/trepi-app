import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_search_result.dart';
import 'package:trepi_app/features/food_search/domain/usecases/search_food.dart';
import 'package:trepi_app/utils/result.dart';

part 'food_search_event.dart';
part 'food_search_state.dart';

class FoodSearchBloc extends Bloc<FoodSearchEvent, FoodSearchState> {
  final SearchFood _searchFood;

  FoodSearchBloc({required SearchFood searchFood}) 
    : _searchFood = searchFood, 
      super(FoodSearchInitialState()) {
    on<GetFoodSearchEvent>(_onGetFoodSearch);
  }

  Future<void> _onGetFoodSearch(
      GetFoodSearchEvent event, 
      Emitter<FoodSearchState> emit
    ) async {
    emit(FoodSearchLoadingState());
    final result = await _searchFood.searchFoods(name: event.name);
    try {

      switch(result) {
        case Ok<List<FoodSearchResult>>(): {
          emit(FoodSearchLoadedState(result.value));
        }
        case Error<List<FoodSearchResult>>(): {
          emit(FoodSearchErrorState(result.error.toString()));
        }
      };
    } catch (e) {
      emit(FoodSearchErrorState(e.toString()));
    }
  }
}