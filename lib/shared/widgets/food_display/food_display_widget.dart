import 'package:flutter/material.dart';
import 'package:trepi_app/core/services/nutrient_data_service.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
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
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildMacroWheel(),
            const SizedBox(height: 16),
            _buildNutrientsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [TrepiColor.orange, TrepiColor.brown],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: TrepiColor.orange.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodDetails.itemDescription ?? 'Unknown Food',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'FDC ID: ${foodDetails.fdcId}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
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
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: Colors.grey,
              ),
              SizedBox(height: 12),
              Text(
                'No nutrient information available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TrepiColor.brown.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.analytics,
                color: TrepiColor.brown,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Nutritional Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: TrepiColor.brown,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<Result<Map<String, dynamic>>>(
          future: NutrientDataService.nutrients,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(TrepiColor.brown),
                  ),
                ),
              );
            }
            
            if (!snapshot.hasData) {
              return Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
            
            final result = snapshot.data!;
            final visibleNutrients = _getVisibleNutrients();
                  
            if (visibleNutrients.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'No nutrients configured for display',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
            
            return switch (result) {
              Ok(value: final nutrientData) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
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
              Error(error: final error) => Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Failed to load nutrient data',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
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
    // TODO: Integrate with NutrientConfigBloc when ready
    // final NutrientConfigState state = getIt<NutrientConfigBloc>().state;
    // final visibleNutrientIdsSet = state is NutrientConfigLoadedState 
    //                                 ? state.commonNutrients.map((nutrient) => nutrient.id).toList()
    //                                 : _defaultNutrientIds;

    const visibleNutrientIdsSet = _defaultNutrientIds;
    
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TrepiColor.brown.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: TrepiColor.brown,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${nutrient.amount?.toStringAsFixed(1) ?? '0'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: TrepiColor.brown,
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  unit.toLowerCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}