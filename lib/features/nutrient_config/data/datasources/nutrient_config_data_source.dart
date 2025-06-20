import 'package:trepi_app/core/services/nutrient_data_service.dart';
import 'package:trepi_app/features/nutrient_config/data/models/nutrient_config_model.dart';
import 'package:trepi_app/utils/result.dart';

class NutrientConfigDataSource {
  Map<String, dynamic>? _nutrientsData;

  NutrientConfigDataSource();

  _loadNutrientsData() async {
    final result = await NutrientDataService.nutrients;
    switch (result) {
      case Ok():
        _nutrientsData = result.value;
        break;
      case Error():
        throw Exception('Failed to load nutrient data: ${result.error}');
    }
  }

  static const List<int> _commonNutrientIds = [
    1079, // Fiber
    1093, // Sodium
    1087, // Calcium
    1089, // Iron
    1162, // Vitamin C
    1165, // Thiamin
    1166, // Riboflavin
    1167, // Niacin
    1175, // Vitamin B-6
    1177, // Folate
    1178, // Vitamin B-12
    1090, // Magnesium
    1091, // Phosphorus
    1092, // Potassium
    1095, // Zinc
    1104, // Vitamin A
    1109, // Vitamin E
    1110, // Vitamin D
  ];

  Future<List<NutrientConfigModel>> getCommonNutrients() async {
    if (_nutrientsData == null) {
      await _loadNutrientsData();
    }
    final Map<String, dynamic> nutrientData = _nutrientsData!;
    
    return _commonNutrientIds.map((id) {
      final data = nutrientData[id.toString()];
      if (data != null) {
        return NutrientConfigModel(
          id: id,
          name: data['name'],
          unitName: data['unit_name'],
          isSelected: _getDefaultSelection(id),
          nutrientNbr: int.parse(data['nutrient_nbr']),
          rank: double.parse(data['rank']),
        );
      }
      return null;
    }).where((config) => config != null).cast<NutrientConfigModel>().toList();
  }

  bool _getDefaultSelection(int nutrientId) {
    const defaultIds = [1079, 1093, 1087, 1089, 1162];
    return defaultIds.contains(nutrientId);
  }
}