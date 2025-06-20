import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/features/nutrient_config/domain/entities/nutrient_config.dart';
import 'package:trepi_app/features/nutrient_config/domain/usecases/get_nutrients.dart';

part 'nutrient_config_event.dart';
part 'nutrient_config_state.dart';

class NutrientConfigBloc extends Bloc<NutrientConfigEvent, NutrientConfigState> {
  final GetNutrients _getNutrients;

  NutrientConfigBloc({
    required getNutrients
  }) : _getNutrients = getNutrients,
      super(NutrientConfigLoadingState()) {    
    on<NutrientConfigLoadEvent>(_onNutrientConfigLoadEvent);
    on<NutrientConfigToggleEvent>(_onNutrientConfigToggleEvent);
    add(NutrientConfigLoadEvent());
  }

  _onNutrientConfigLoadEvent(
    NutrientConfigLoadEvent event, 
    Emitter<NutrientConfigState> emit
  ) async {
    emit(NutrientConfigLoadingState());
    try {
      final nutrients = await _getNutrients.getCommonNutrients();
      emit(NutrientConfigLoadedState(nutrients));
    } catch (e) {
      emit(NutrientConfigErrorState(e.toString()));
      debugPrint('Error loading nutrients: $e');
    }
  }

  _onNutrientConfigToggleEvent(
    NutrientConfigToggleEvent event,
    Emitter<NutrientConfigState> emit
  ) {
    if (state is NutrientConfigLoadedState) {
      final currentState = state as NutrientConfigLoadedState;
      emit(NutrientConfigLoadingState());
      final updatedNutrients = currentState.commonNutrients.map((nutrient) {
        if (nutrient.id == event.nutrientId) {
          return nutrient.copyWith(isSelected: event.isEnabled);
        }
        return nutrient;
      }).toList();
      emit(NutrientConfigLoadedState(updatedNutrients));
    } else {
      emit(NutrientConfigErrorState('Cannot toggle nutrient, state is not loaded'));
    }
  }
}