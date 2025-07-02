part of 'nutrient_config_bloc.dart';

sealed class NutrientConfigEvent extends Equatable {
  const NutrientConfigEvent();

  @override
  List<Object?> get props => [];
}

class NutrientConfigLoadEvent extends NutrientConfigEvent {}

class NutrientConfigToggleEvent extends NutrientConfigEvent {
  final int nutrientId;
  final bool isEnabled;

  const NutrientConfigToggleEvent({required this.nutrientId, required this.isEnabled});

  @override
  List<Object?> get props => [nutrientId, isEnabled];
}

class NutrientConfigSaveEvent extends NutrientConfigEvent {
  final List<int> selectedNutrientIds;

  const NutrientConfigSaveEvent({required this.selectedNutrientIds});

  @override
  List<Object?> get props => [selectedNutrientIds];
}