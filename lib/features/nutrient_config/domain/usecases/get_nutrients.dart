import 'package:trepi_app/features/nutrient_config/domain/entities/nutrient_config.dart';
import 'package:trepi_app/features/nutrient_config/domain/repositories/nutrient_config_repository.dart';

class GetNutrients {
  final NutrientConfigRepository _repository;

  GetNutrients(this._repository);

  Future<List<NutrientConfig>> getCommonNutrients() async {
    return await _repository.getCommonNutrients();
  }
}