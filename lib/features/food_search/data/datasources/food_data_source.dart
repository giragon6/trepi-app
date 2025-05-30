import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:trepi_app/utils/result.dart';
import 'package:trepi_app/features/food_search/data/models/food_details_model.dart';

class FoodDataSource {
  final String _host = ''; // tba
  final int _port = 0; // tba

  Future<Result<FoodDetailsModel>> fetchFoodDetailsById(int fdcId) async {
    try {
      final response = await http.get(Uri.parse('/$_host:$_port/food/$fdcId'));
      if (response.statusCode == 200) {
        final foodDetails = FoodDetailsModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        return Result.ok(foodDetails);
      } else {
        return const Result.error(
          HttpException('Invalid response from server', uri: null),
        );
      }
    } on Exception catch (e) {
      return Result.error(Exception('Failed to load food details: $e'));
    }
  }
  
  Future<void> saveData(FoodDetailsModel data) async{
    // Implement save logic
  }

  Future<void> deleteData(FoodDetailsModel data) async{
    // Implement delete logic
  }
}