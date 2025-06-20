import 'package:trepi_app/features/nutrient_config/data/datasources/nutrient_config_data_source.dart';
import 'package:trepi_app/features/nutrient_config/domain/entities/nutrient_config.dart';
import 'package:trepi_app/features/nutrient_config/domain/repositories/nutrient_config_repository.dart';

class NutrientConfigRepositoryImpl extends NutrientConfigRepository {
  final NutrientConfigDataSource _dataSource;

  NutrientConfigRepositoryImpl(this._dataSource);

  @override
  Future<List<NutrientConfig>> getCommonNutrients() {
    return _dataSource.getCommonNutrients();
  }
}