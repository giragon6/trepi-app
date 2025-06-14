class MealFood {
  final String fdcId;
  final String description;
  final String? error;

  const MealFood({
    required this.fdcId,
    required this.description,
    this.error,
  });
}