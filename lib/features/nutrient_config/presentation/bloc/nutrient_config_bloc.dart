import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/features/nutrient_config/domain/entities/nutrient_config.dart';
import 'package:trepi_app/features/nutrient_config/domain/usecases/get_nutrients.dart';
import 'package:trepi_app/utils/result.dart';

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
    on<NutrientConfigSaveEvent>(_onNutrientConfigSaveEvent);
    add(NutrientConfigLoadEvent());
  }

  _onNutrientConfigLoadEvent(
    NutrientConfigLoadEvent event, 
    Emitter<NutrientConfigState> emit
  ) async {
    emit(NutrientConfigLoadingState());
    try {
      final nutrients = await _getNutrients.getAllNutrientsWithSelection();
      switch (nutrients) {
        case Ok<List<NutrientConfig>>():
          final selectedNutrients = nutrients.value;
          if (selectedNutrients.isEmpty) {
            final commonNutrients = await _getNutrients.getCommonNutrients();
            emit(NutrientConfigLoadedState(commonNutrients));
          } else {
            emit(NutrientConfigLoadedState(selectedNutrients));
          }
        case Error():
          emit(NutrientConfigErrorState(nutrients.error.toString()));
      }
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
      final updatedNutrients = currentState.selectedNutrients.map((nutrient) {
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

  _onNutrientConfigSaveEvent(
    NutrientConfigSaveEvent event,
    Emitter<NutrientConfigState> emit
  ) async {
    if (state is NutrientConfigLoadedState) {
      final currentState = state as NutrientConfigLoadedState;
      try {
        debugPrint('Saving selected nutrient IDs: ${event.selectedNutrientIds}');
        final result = await _getNutrients.setSelectedNutrientIds(event.selectedNutrientIds);
        switch (result) {
          case Ok<void>():
            emit(NutrientConfigLoadedState(currentState.selectedNutrients));
            break;
          case Error():
            emit(NutrientConfigErrorState(result.error.toString()));
        }
      } catch (e) {
        emit(NutrientConfigErrorState(e.toString()));
      }
    } else {
      emit(NutrientConfigErrorState('Cannot save nutrients, state is not loaded'));
    }
  }

  
}