import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meal_details/meal_details_bloc.dart';
import 'package:trepi_app/shared/widgets/food_display/macro_wheel.dart';

class MealDetailsPage extends StatefulWidget {
  final String userId;
  final String mealId;

  const MealDetailsPage({super.key, required this.userId, required this.mealId});

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MealDetailsBloc>().add(GetMealDetailsEvent(widget.userId, widget.mealId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MealDetailsBloc, MealDetailsState>(
        builder: (context, state) {
          String mealName = 'Meal Details';
          if (state is MealDetailsLoadedState) {
            mealName = state.meal.name;
          }
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          TrepiColor.orange,
                          TrepiColor.orange.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  title: Text(
                    mealName,
                    style: const TextStyle(
                      color: TrepiColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                backgroundColor: TrepiColor.orange,
                foregroundColor: TrepiColor.white,
                actions: [
                  if (state is MealDetailsLoadedState)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        context.push('/meals/${widget.mealId}/edit');
                      },
                      tooltip: 'Edit Meal',
                    ),
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: TrepiColor.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: _mealContent(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _mealContent(BuildContext context) {
    return BlocBuilder<MealDetailsBloc, MealDetailsState>(
      builder: (context, state) {
        if (state is MealDetailsLoadingState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(TrepiColor.orange),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading meal details...',
                    style: TextStyle(
                      color: TrepiColor.brown,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is MealDetailsLoadedState) {
          final meal = state.meal;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meal Overview Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: TrepiColor.brown.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: TrepiColor.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.restaurant_menu,
                                color: TrepiColor.orange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                meal.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: TrepiColor.brown,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: TrepiColor.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatColumn(
                                'Total Weight',
                                '${meal.totalGrams.toStringAsFixed(1)}g',
                                TrepiColor.brown,
                              ),
                              Container(
                                width: 1,
                                height: 30,
                                color: TrepiColor.brown.withValues(alpha: 0.2),
                              ),
                              _buildStatColumn(
                                'Foods',
                                '${meal.foods.length}',
                                TrepiColor.brown,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Macronutrient Breakdown Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: TrepiColor.brown.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: TrepiColor.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.pie_chart,
                                color: TrepiColor.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Macronutrient Breakdown',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: TrepiColor.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        MacroWheel(
                          proteinGrams: meal.proteinGrams,
                          carbGrams: meal.carbGrams,
                          fatGrams: meal.fatGrams,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroStat('Protein', meal.proteinGrams, TrepiColor.green),
                            _buildMacroStat('Carbs', meal.carbGrams, TrepiColor.orange),
                            _buildMacroStat('Fat', meal.fatGrams, TrepiColor.brown),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Foods List Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: TrepiColor.brown.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: TrepiColor.brown.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.list_alt,
                                color: TrepiColor.brown,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Foods in this meal',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: TrepiColor.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (meal.foods.isEmpty)
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.no_food,
                                  size: 48,
                                  color: TrepiColor.brown.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No foods added to this meal',
                                  style: TextStyle(
                                    color: TrepiColor.brown.withValues(alpha: 0.7),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: meal.foods.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final food = meal.foods[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: TrepiColor.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: TrepiColor.brown.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: TrepiColor.orange.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.restaurant,
                                          color: TrepiColor.orange,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              food.description,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                color: TrepiColor.brown,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${food.quantity.toStringAsFixed(1)}g',
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: TrepiColor.brown.withValues(alpha: 0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          _buildMacroChip('P', food.proteinGrams, TrepiColor.green),
                                          const SizedBox(height: 4),
                                          _buildMacroChip('C', food.carbGrams, TrepiColor.orange),
                                          const SizedBox(height: 4),
                                          _buildMacroChip('F', food.fatGrams, TrepiColor.brown),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Edit Action Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [TrepiColor.orange, TrepiColor.orange.withValues(alpha: 0.8)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: TrepiColor.orange.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/meals/${widget.mealId}/edit');
                    },
                    icon: const Icon(Icons.edit, color: TrepiColor.white),
                    label: const Text(
                      'Edit This Meal',
                      style: TextStyle(
                        color: TrepiColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          );
        } else if (state is MealDetailsErrorState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Error loading meal details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: TrepiColor.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.error,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: TrepiColor.brown.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MealDetailsBloc>().add(
                        GetMealDetailsEvent(widget.userId, widget.mealId),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TrepiColor.orange,
                      foregroundColor: TrepiColor.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Text(
              'Unknown state: ${state.runtimeType}',
              style: TextStyle(color: TrepiColor.brown),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMacroStat(String label, double grams, Color color) {
    return Column(
      children: [
        Text(
          '${grams.toStringAsFixed(1)}g',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMacroChip(String label, double grams, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: ${grams.toStringAsFixed(0)}g',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}