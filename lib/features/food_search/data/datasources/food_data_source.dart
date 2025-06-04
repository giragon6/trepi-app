import 'dart:convert';
import 'dart:io';
import 'package:trepi_app/core/network/api_client.dart';
import 'package:trepi_app/utils/result.dart';
import 'package:trepi_app/features/food_search/data/models/food_details_model.dart';

class FoodDataSource {
  final ApiClient _apiClient;

  FoodDataSource(this._apiClient);

  Future<Result<FoodDetailsModel>> fetchFoodDetailsById(int fdcId) async {
    try {
      final res = await _apiClient.get('/foods/$fdcId');
      if (res.statusCode == 200) {
        return Result.ok(
          FoodDetailsModel.fromJson(json.decode(res.body)['food']),
        );
      }
      return Result.error(HttpException('Bad status: ${res.statusCode}', uri: null),);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to load food details: $e'));
    }
  }
  
  Future<void> saveData(FoodDetailsModel data) async{
    // TODO: Implement save logic
  }

  Future<void> deleteData(FoodDetailsModel data) async{
    // TODO: Implement delete logic
  }
}