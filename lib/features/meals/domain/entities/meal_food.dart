class MealFood {
  final int fdcId;
  final String description;
  final double quantity; 
  final double proteinGrams;
  final double carbGrams;
  final double fatGrams;
  final String? error;

  const MealFood({
    required this.fdcId,
    required this.description,
    required this.quantity,
    required this.proteinGrams,
    required this.carbGrams,
    required this.fatGrams,
    this.error,
  });
}