import 'package:trepi_app/features/nutrient_config/domain/entities/nutrient_config.dart';

abstract class NutrientConfigRepository {
  Future<List<NutrientConfig>> getCommonNutrients();
}