import 'package:trepi_app/features/food_search/domain/entities/food_search_result.dart';
import 'package:trepi_app/features/food_search/domain/repositories/food_repository.dart';
import 'package:trepi_app/utils/result.dart';

class SearchFood {
  final FoodRepository foodRepository;

  SearchFood(this.foodRepository);

  Future<Result<List<FoodSearchResult>>> searchFoods({
    String? name,
    String? dataType,
    int? pageSize,
    int? pageNumber,
    String? sortBy,
    String? sortOrder,
    String? brandOwner,
    String? brandName,
    String? ingredient,
    String? brandedFoodCategory
  }) async => foodRepository.searchFoods(
    name: name,
    dataType: dataType,
    pageSize: pageSize,
    pageNumber: pageNumber,
    sortBy: sortBy,
    sortOrder: sortOrder,
    brandOwner: brandOwner,
    brandName: brandName,
    ingredient: ingredient,
    brandedFoodCategory: brandedFoodCategory,
  );
}