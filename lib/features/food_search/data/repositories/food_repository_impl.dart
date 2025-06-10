import 'package:trepi_app/features/food_search/data/datasources/food_data_source.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_search_result.dart';
import 'package:trepi_app/features/food_search/domain/repositories/food_repository.dart';
import 'package:trepi_app/utils/result.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodDataSource _dataSource;

  FoodRepositoryImpl(this._dataSource);

  @override
  Future<Result<FoodDetails>> getFoodDetailsById(int fdcId) async {
    return await _dataSource.fetchFoodDetailsById(fdcId);
  }

  @override
  Future<Result<List<FoodSearchResult>>> searchFoods({
    String? name,
    String? dataType,
    int? pageSize = 10,
    int? pageNumber = 1,
    String? sortBy,
    String? sortOrder,
    String? brandOwner,
    String? brandName,
    String? ingredient,
    String? brandedFoodCategory
  }) {
    return _dataSource.searchFoods(
      name: name,
      dataType: dataType,
      pageSize: pageSize,
      pageNumber: pageNumber,
      sortBy: sortBy,
      sortOrder: sortOrder,
      brandOwner: brandOwner,
      brandName: brandName,
      ingredient: ingredient,
      brandedFoodCategory: brandedFoodCategory
    );
  }
}