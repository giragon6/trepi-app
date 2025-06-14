import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:trepi_app/utils/result.dart'; 

class NutrientLookup {
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