import 'package:trepi_app/features/nutrient_config/domain/entities/nutrient_config.dart';
import 'package:trepi_app/utils/result.dart';

abstract class NutrientConfigRepository {
  Future<List<NutrientConfig>> getCommonNutrients();
  Future<Result<List<NutrientConfig>>> getSelectedNutrients();
  Future<Result<void>> setSelectedNutrientIds(List<int> ids);
  Future<Result<List<NutrientConfig>>> getAllNutrientsWithSelection();
}