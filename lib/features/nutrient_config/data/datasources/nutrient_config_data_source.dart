import 'package:shared_preferences/shared_preferences.dart';
import 'package:trepi_app/core/services/nutrient_data_service.dart';
import 'package:trepi_app/features/nutrient_config/data/models/nutrient_config_model.dart';
import 'package:trepi_app/utils/result.dart';

class NutrientConfigDataSource {
  Map<String, dynamic>? _nutrientsData;
  static const _key = 'selected_nutrient_ids';

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

  Future<Result<List<NutrientConfigModel>>> getSelectedNutrients() async {
    if (_nutrientsData == null) {
      await _loadNutrientsData();
    }
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_key)) {
      return Result.ok([]);
    }
    final data = prefs.getStringList(_key)?.map(int.parse).toList() ?? [];
    if (data.isEmpty) {
      return Result.ok([]);
    }
    final selectedNutrients = data.map((id) {
      final nutrientData = _nutrientsData?[id.toString()];
      if (nutrientData != null) {
        return NutrientConfigModel(
          id: id,
          name: nutrientData['name'],
          unitName: nutrientData['unit_name'],
          isSelected: true,
          nutrientNbr: int.parse(nutrientData['nutrient_nbr']),
          rank: double.parse(nutrientData['rank']),
        );
      }
      return null;
    }).where((config) => config != null).cast<NutrientConfigModel>().toList();
    return Result.ok(selectedNutrients);
  }

  Future<Result<List<int>>> getSelectedNutrientIds() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_key)) {
      return Result.ok([]);
    }
    final data = prefs.getStringList(_key)?.map(int.parse).toList() ?? [];
    return Result.ok(data);
  }

  Future<Result<void>> setSelectedNutrientIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    if (ids.isEmpty) {
      return Result.error(Exception('Selected nutrient IDs list cannot be empty'));
    }
    final res = await prefs.setStringList(_key, ids.map((e) => e.toString()).toList());
    if (!res) {
      return Result.error(Exception('Failed to save selected nutrient IDs'));
    }
    return Result.ok(null);
  }

  Future<Result<List<NutrientConfigModel>>> getAllNutrientsWithSelection() async {
    try {
      final allNutrients = await getCommonNutrients(); 
      final selectedIdsRes = await getSelectedNutrientIds(); 
      List<int> selectedIds;
      switch (selectedIdsRes) {
        case Ok():
          selectedIds = selectedIdsRes.value;
          break;
        case Error():
          selectedIds = [];
          break;
      }
      return Result.ok(allNutrients.map((n) => n.copyWith(isSelected: selectedIds.contains(n.id))).toList());
    } catch (e) {
      return Result.error(Exception('Failed to load nutrients: $e'));
    }
  }
}