import 'package:flutter/material.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/core/services/nutrient_data_service.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
import 'package:trepi_app/features/nutrient_config/presentation/bloc/nutrient_config_bloc.dart';
import 'package:trepi_app/shared/widgets/food_display/macro_wheel.dart';
import 'package:trepi_app/utils/get_nutrient_amount.dart';
import 'package:trepi_app/utils/result.dart';

class FoodDisplayWidget extends StatelessWidget {
  final FoodDetails foodDetails;

  const FoodDisplayWidget({
    super.key,
    required this.foodDetails
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildMacroWheel(),
            const SizedBox(height: 16),
            Expanded(child: _buildNutrientsSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodDetails.itemDescription ?? 'Unknown Food',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'FDC ID: ${foodDetails.fdcId}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroWheel() {
    final proteinGramsResult = getNutrientAmount(1003, foodDetails);
    final carbGramsResult = getNutrientAmount(1005, foodDetails);
    final fatGramsResult = getNutrientAmount(1004, foodDetails);
    return MacroWheel(
      proteinGrams: proteinGramsResult is Ok<double>
          ? proteinGramsResult.value
          : 0.0,
      carbGrams: carbGramsResult is Ok<double>
          ? carbGramsResult.value
          : 0.0,
      fatGrams: fatGramsResult is Ok<double>
          ? fatGramsResult.value
          : 0.0,
    );
  }

  Widget _buildNutrientsSection() {
    if (foodDetails.nutrients.isEmpty) {
      return const Text('No nutrient information available');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutritional Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
        child: FutureBuilder<Result<Map<String, dynamic>>>(
          future: NutrientDataService.nutrients,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }
            
            final result = snapshot.data!;

            final visibleNutrients = _getVisibleNutrients();
                  
            if (visibleNutrients.isEmpty) {
              return const Center(
                child: Text('No nutrients configured for display'),
              );
            }
            
            return switch (result) {
              Ok(value: final nutrientData) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: visibleNutrients.length,
                itemBuilder: (context, index) {
                  final nutrient = visibleNutrients[index];
                  return _buildNutrientCard(nutrient, nutrientData);
                },
              ),
              Error(error: final error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    const Text(
                      'Failed to load nutrient data',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            };
          },
        ),
        )
      ],
    );
  }

  static const _defaultNutrientIds = [
    1079, // Fiber
    1093, // Sodium
    1087, // Calcium
    1089, // Iron
    1162, // Vitamin C
  ];

  List<dynamic> _getVisibleNutrients() {
    final NutrientConfigState state = getIt<NutrientConfigBloc>().state;

    // TODO: she don't work yet 😔
    // final visibleNutrientIdsSet = state is NutrientConfigLoadedState 
    //                                 ? state.commonNutrients.map((nutrient) => nutrient.id).toList()
    //                                 : _defaultNutrientIds;

    final visibleNutrientIdsSet = _defaultNutrientIds;
    
    final visibleNutrients = foodDetails.nutrients
        .where((nutrient) => visibleNutrientIdsSet.contains(nutrient.nutrientId))
        .toList();
    
    return visibleNutrients;
  }

  Widget _buildNutrientCard(dynamic nutrient, Map<String, dynamic> nutrientData) {
    final nutrientInfo = nutrientData[nutrient.nutrientId.toString()];
    final name = nutrientInfo?['name'] ?? 'Unknown Nutrient';
    final unit = nutrientInfo?['unit_name'] ?? '';
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '${nutrient.amount?.toStringAsFixed(1) ?? '0'} ${unit.toLowerCase()}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}