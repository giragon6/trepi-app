class FoodNutrient {
  final int nutrientId;
  final double amount;
  final double? dataPoints;
  final int? derivationId;
  final String? footnote;
  final double? percentDailyValue;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FoodNutrient({
    required this.nutrientId,
    required this.amount,
    this.dataPoints,
    this.derivationId,
    this.footnote,
    this.percentDailyValue,
    this.createdAt,
    this.updatedAt,
  });
}