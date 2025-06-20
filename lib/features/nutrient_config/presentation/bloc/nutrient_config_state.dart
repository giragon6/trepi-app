part of 'nutrient_config_bloc.dart';

sealed class NutrientConfigState extends Equatable {
  const NutrientConfigState();

  @override
  List<Object?> get props => [];
}

class NutrientConfigLoadingState extends NutrientConfigState {}

class NutrientConfigLoadedState extends NutrientConfigState {
  final List<NutrientConfig> commonNutrients;

  const NutrientConfigLoadedState(this.commonNutrients);

  @override
  List<Object?> get props => [commonNutrients];
}

class NutrientConfigErrorState extends NutrientConfigState {
  final String error;

  const NutrientConfigErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
