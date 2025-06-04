import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
import 'package:trepi_app/features/food_search/domain/repositories/food_repository.dart';
import 'package:trepi_app/utils/result.dart';

class RequestFood {
  final FoodRepository foodRepository;

  RequestFood(this.foodRepository);

  Future<Result<FoodDetails>> getFoodDetails(int fdcId) async => 
    foodRepository.getFoodDetailsById(fdcId);
}