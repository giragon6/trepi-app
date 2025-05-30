import 'package:trepi_app/features/food_search/data/datasources/food_data_source.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
import 'package:trepi_app/features/food_search/domain/repositories/food_repository.dart';
import 'package:trepi_app/utils/result.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodDataSource _dataSource;

  FoodRepositoryImpl(this._dataSource);

  @override
  Future<Result<FoodDetails>> getFoodDetailsById(int fdcId) async {
    return await _dataSource.fetchFoodDetailsById(fdcId);
  }
}