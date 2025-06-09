class FoodSearchResult {
  final int fdcId;
  final String? dataType;
  final String itemDescription;

  const FoodSearchResult({
    required this.fdcId,
    this.dataType,
    required this.itemDescription,
  });
}