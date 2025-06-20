abstract class NutrientConfig {
  final int id;
  final String name;
  final String unitName;
  final bool isSelected;

  final int nutrientNbr;
  final double rank;

  NutrientConfig({
    required this.id,
    required this.name,
    required this.unitName,
    required this.isSelected,
    required this.nutrientNbr,
    required this.rank,
  });

  NutrientConfig copyWith({
    int? id,
    String? name,
    String? unitName,
    bool? isSelected,
  });
}