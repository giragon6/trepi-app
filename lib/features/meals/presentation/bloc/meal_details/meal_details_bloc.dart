import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trepi_app/features/meals/domain/entities/meal.dart';
import 'package:trepi_app/features/meals/domain/usecases/get_meal_details.dart';
import 'package:trepi_app/features/meals/domain/usecases/update_meal_details.dart';
import 'package:trepi_app/utils/result.dart';

part 'meal_details_event.dart';
part 'meal_details_state.dart';

class MealDetailsBloc extends Bloc<MealDetailsEvent, MealDetailsState> {
  final GetMealDetails _getMealDetails;
  final UpdateMealDetails _updateMealDetails;

  MealDetailsBloc({
    required GetMealDetails getMealDetails,
    required UpdateMealDetails updateMealDetails,
  })  : _getMealDetails = getMealDetails,
        _updateMealDetails = updateMealDetails,
        super(MealDetailsInitialState()) {
    on<GetMealDetailsEvent>(_onGetMealDetails);
    on<UpdateMealDetailsEvent>(_onUpdateMeal);
  }

  Future<void> _onGetMealDetails(
    GetMealDetailsEvent event, 
    Emitter<MealDetailsState> emit
  ) async {
    emit(MealDetailsLoadingState());
    final result = await _getMealDetails(event.userId, event.mealId);
    switch (result) {
      case Ok():
        final meal = result.value;
        emit(MealDetailsLoadedState(meal));
        break;
      case Error():
        final error = result.error;
        emit(MealDetailsErrorState(error.toString()));
        break;
    }
  }

  Future<void> _onUpdateMeal(
    UpdateMealDetailsEvent event, 
    Emitter<MealDetailsState> emit
  ) async {
    emit(MealDetailsLoadingState());
    final result = await _updateMealDetails(event.userId, event.meal);
    switch (result) {
      case Ok():
        add(GetMealDetailsEvent(event.userId, event.meal.id));
        break;
      case Error():
        final error = result.error;
        emit(MealDetailsErrorState(error.toString()));
        break;
    }
  }
}