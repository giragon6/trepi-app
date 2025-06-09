import 'dart:convert';
import 'dart:io';
import 'package:trepi_app/core/network/api_client.dart';
import 'package:trepi_app/features/food_search/data/models/food_search_result_model.dart';
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

  Future<Result<List<FoodSearchResultModel>>> searchFoods(
    String? name,
    String? dataType,
    int? pageSize,
    int? pageNumber,
    String? sortBy,
    String? sortOrder,
    String? brandOwner,
    String? brandName,
    String? ingredient,
    String? brandedFoodCategory,
  ) async {
    if (name == null && dataType == null && pageSize == null &&
        pageNumber == null && sortBy == null && sortOrder == null &&
        brandOwner == null && brandName == null && ingredient == null &&
        brandedFoodCategory == null) {
      return Result.error(Exception('At least one search parameter must be provided'));
    }
    try {
      final queryParameters = <String, String>{};
      if (name != null) queryParameters['name'] = name;
      if (dataType != null) queryParameters['dataType'] = dataType;
      if (pageSize != null) queryParameters['pageSize'] = pageSize.toString();
      if (pageNumber != null) queryParameters['pageNumber'] = pageNumber.toString();
      if (sortBy != null) queryParameters['sortBy'] = sortBy;
      if (sortOrder != null) queryParameters['sortOrder'] = sortOrder;
      if (brandOwner != null) queryParameters['brandOwner'] = brandOwner;
      if (brandName != null) queryParameters['brandName'] = brandName;
      if (ingredient != null) queryParameters['ingredient'] = ingredient;
      if (brandedFoodCategory != null) {
        queryParameters['brandedFoodCategory'] = brandedFoodCategory;
      }
      final res = await _apiClient.get(
        '/foods',
        queryParams: queryParameters,
      );
      if (res.statusCode == 200) {
        final List<dynamic> foodsJson = json.decode(res.body)['foods'];
        final List<FoodSearchResultModel> foods = foodsJson
            .map((food) => FoodSearchResultModel.fromJson(food))
            .toList();
        return Result.ok(foods);
      }
      return Result.error(HttpException('Bad status: ${res.statusCode}', uri: null),);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to search foods: $e'));
    }
  }
  
  Future<void> saveData(FoodDetailsModel data) async{
    // TODO: Implement save logic
  }

  Future<void> deleteData(FoodDetailsModel data) async{
    // TODO: Implement delete logic
  }
}

class SimpleFoodModel {
}