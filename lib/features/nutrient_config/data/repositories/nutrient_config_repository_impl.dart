import 'package:trepi_app/features/nutrient_config/data/datasources/nutrient_config_data_source.dart';
import 'package:trepi_app/features/nutrient_config/data/models/nutrient_config_model.dart';
import 'package:trepi_app/features/nutrient_config/domain/entities/nutrient_config.dart';
import 'package:trepi_app/features/nutrient_config/domain/repositories/nutrient_config_repository.dart';
import 'package:trepi_app/utils/result.dart';

class NutrientConfigRepositoryImpl extends NutrientConfigRepository {
  final NutrientConfigDataSource _dataSource;

  NutrientConfigRepositoryImpl(this._dataSource);

  @override
  Future<List<NutrientConfigModel>> getCommonNutrients() {
    return _dataSource.getCommonNutrients();
  }

  @override
  Future<Result<List<NutrientConfigModel>>> getSelectedNutrients() {
    return _dataSource.getSelectedNutrients();
  }

  @override
  Future<Result<List<NutrientConfigModel>>> getAllNutrientsWithSelection() async {
    return _dataSource.getAllNutrientsWithSelection();
  }

  @override
  Future<Result<void>> setSelectedNutrientIds(List<int> ids) {
    return _dataSource.setSelectedNutrientIds(ids);
  }
}