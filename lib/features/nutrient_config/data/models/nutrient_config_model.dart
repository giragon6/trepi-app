import 'package:trepi_app/features/nutrient_config/domain/entities/nutrient_config.dart';

class NutrientConfigModel extends NutrientConfig {
  NutrientConfigModel({
    required this.id,
    required this.name,
    required this.unitName,
    required this.isSelected,
    required int nutrientNbr,
    required double rank,
  }): super(
    id: id,
    name: name,
    unitName: unitName,
    isSelected: isSelected,
    nutrientNbr: 0, 
    rank: 999999, 
  );

  final int id;
  final String name;
  final String unitName;
  final bool isSelected;

  final int nutrientNbr = 0; 
  final double rank = 0; 

  factory NutrientConfigModel.fromJson(
    Map<String, dynamic> json, 
    int id
  ) {
    return NutrientConfigModel(
      id: id,
      name: json['name'] as String,
      unitName: json['unit_name'] as String,
      isSelected: false,

      nutrientNbr: int.parse(json['nutrient_nbr']),
      rank: double.parse(json['rank']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit_name': unitName,
      'nutrient_nbr': nutrientNbr,
      'rank': rank,
    };
  }

  NutrientConfigModel withError(String errorMessage) {
    return NutrientConfigModel(
      id: -1,
      name: 'Error loading nutrient',
      unitName: '',
      isSelected: false,
      nutrientNbr: 0,
      rank: 999999.0,
    );
  }

  @override
  NutrientConfigModel copyWith({
    int? id,
    String? name,
    String? unitName,
    bool? isSelected,
  }) {
    return NutrientConfigModel(
      id: id ?? this.id,
      name: name ?? this.name,
      unitName: unitName ?? this.unitName,
      isSelected: isSelected ?? this.isSelected,
      nutrientNbr: nutrientNbr,
      rank: rank,
    );
  }
}