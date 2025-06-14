import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trepi_app/features/meals/domain/entities/meal.dart';
import 'package:trepi_app/features/meals/domain/repositories/meal_repository.dart';
import 'package:trepi_app/utils/result.dart';

part 'meals_event.dart';
part 'meals_state.dart';

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final MealRepository _mealRepository;

  MealsBloc(this._mealRepository) : super(MealsInitialState()) {
    on<GetMealsEvent>(_onLoadMeals);
    on<AddMealEvent>(_onAddMeal);
    on<DeleteMealEvent>(_onDeleteMeal);
  }

  Future<void> _onLoadMeals(GetMealsEvent event, Emitter<MealsState> emit) async {
    emit(MealsLoadingState());
    final result = await _mealRepository.getMeals(event.userId);
    switch (result) {
      case Ok<List<Meal>>():
        final meals = result.value;
        emit(MealsLoadedState(meals));
        break;
      case Error<List<Meal>>():
        final error = result.error;
        emit(MealsErrorState(error.toString()));
        break;
    }
  }

  Future<void> _onAddMeal(AddMealEvent event, Emitter<MealsState> emit) async {
    final result = await _mealRepository.addMeal(event.userId, event.meal);
    switch (result) {
      case Ok():
        add(GetMealsEvent(event.userId));
        break;
      case Error():
        final error = result.error;
        emit(MealsErrorState(error.toString()));
        break;
    }
  }

  Future<void> _onDeleteMeal(DeleteMealEvent event, Emitter<MealsState> emit) async {
    final result = await _mealRepository.deleteMeal(event.userId, event.mealId);
    switch (result) {
      case Ok():
        add(GetMealsEvent(event.userId));
        break;
      case Error():
        final error = result.error;
        emit(MealsErrorState(error.toString()));
        break;
    }
  }
}