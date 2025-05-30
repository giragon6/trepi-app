import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
import 'package:trepi_app/utils/result.dart';

abstract class FoodRepository {
    Future<Result<FoodDetails>> getFoodDetailsById(int fdcId);
}