import 'package:trepi_app/features/nutrient_config/domain/entities/nutrient_config.dart';
import 'package:trepi_app/features/nutrient_config/domain/repositories/nutrient_config_repository.dart';
import 'package:trepi_app/utils/result.dart';

class GetNutrients {
  final NutrientConfigRepository _repository;

  GetNutrients(this._repository);

  Future<List<NutrientConfig>> getCommonNutrients() async {
    return await _repository.getCommonNutrients();
  }

  Future<Result<List<NutrientConfig>>> getSelectedNutrients() async {
    return _repository.getSelectedNutrients();
  }

  Future<Result<void>> setSelectedNutrientIds(List<int> ids) async {
    return _repository.setSelectedNutrientIds(ids);
  }

  Future<Result<List<NutrientConfig>>> getAllNutrientsWithSelection() {
    return _repository.getAllNutrientsWithSelection();
  }
}