import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_search_result.dart';
import 'package:trepi_app/utils/result.dart';

abstract class FoodRepository {
  Future<Result<FoodDetails>> getFoodDetailsById(int fdcId);
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
    String? brandedFoodCategory,
  });
}