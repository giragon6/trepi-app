import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:trepi_app/utils/result.dart'; 

enum Macro {
  protein(1003, 'Protein', 'Protein', 'g'),
  fat(1004, 'Fat', 'Fat', 'g'),
  carbohydrate(1005, 'Carbohydrates', 'Carbs', 'g');

  const Macro(this.id, this.name, this.nickname, this.unitName);

  final int id;
  final String name;
  final String nickname;
  final String unitName;

  static Macro? fromId(int id) {
    try {
      return Macro.values.firstWhere((macro) => macro.id == id);
    } catch (e) {
      return null;
    }
  }

  static String? getName(int id) {
    return fromId(id)?.name;
  }
}

class NutrientDataService {
  static Result<Map<String, dynamic>>? _nutrientResult;

  
  static Future<Result<Map<String, dynamic>>> get nutrients async {
    if (_nutrientResult == null) {
      try {
        final String jsonString = await rootBundle.loadString('assets/data/nutrient_data.json');
        
        if (jsonString.trim().isEmpty) {
          _nutrientResult = Result.error(Exception('JSON file is empty'));
        } else {
          final data = json.decode(jsonString) as Map<String, dynamic>;
          _nutrientResult = Result.ok(data);
        }
      } catch (e) {
        _nutrientResult = Result.error(Exception('Failed to load nutrient data: $e'));
      }
    }
    return _nutrientResult!;
  }
  
  static Future<String> getName(int id) async {
    final result = await nutrients;
    switch (result) {
      case Ok(value: final data):
        return data[id.toString()]?['name'] ?? 'Unknown Nutrient (ID: $id)';
      case Error():
        return 'Unknown Nutrient (ID: $id)';
    }
  }
  
  static Future<String> getUnitName(int id) async {
    final result = await nutrients;
    switch (result) {
      case Ok(value: final data):
        return data[id.toString()]?['unit_name'] ?? '';
      case Error():
        return '';
    }
  }
  
  static Future<double> getRank(int id) async {
    final result = await nutrients;
    switch (result) {
      case Ok(value: final data):
        final rankStr = data[id.toString()]?['rank'] ?? '999999.0';
        return double.tryParse(rankStr) ?? 999999.0;
      case Error():
        return 999999.0;
    }
  }
}