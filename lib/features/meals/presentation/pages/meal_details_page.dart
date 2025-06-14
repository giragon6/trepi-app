import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meal_details/meal_details_bloc.dart';
import 'package:trepi_app/shared/widgets/food_display/macro_wheel.dart';

class MealDetailsPage extends StatefulWidget {
  final String userId;
  final String mealId;

  const MealDetailsPage({Key? key, required this.userId, required this.mealId}) : super(key: key);

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
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: _mealContent(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/meals/${widget.mealId}/edit');
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _mealContent(BuildContext context) {
    return BlocBuilder<MealDetailsBloc, MealDetailsState>(
      builder: (context, state) {
        if (state is MealDetailsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MealDetailsLoadedState) {
          final meal = state.meal;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: ${meal.totalGrams.toStringAsFixed(1)}g',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Macronutrient Breakdown',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        MacroWheel(
                          proteinGrams: meal.proteinGrams,
                          carbGrams: meal.carbGrams,
                          fatGrams: meal.fatGrams,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Foods',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (meal.foods.isEmpty)
                          const Text('No foods added to this meal')
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: meal.foods.length,
                            itemBuilder: (context, index) {
                              final food = meal.foods[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                elevation: 2,
                                child: ListTile(
                                  title: Text(food.description),
                                  subtitle: Text('${food.quantity.toStringAsFixed(1)}g'),
                                  trailing: SingleChildScrollView(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'P: ${food.proteinGrams.toStringAsFixed(1)}g',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'C: ${food.carbGrams.toStringAsFixed(1)}g',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'F: ${food.fatGrams.toStringAsFixed(1)}g',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),)
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
            )],
            ),
          );
        } else if (state is MealDetailsErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading meal details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<MealDetailsBloc>().add(
                      GetMealDetailsEvent(widget.userId, widget.mealId),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return Center(child: Text('Unknown state: ${state.runtimeType}'));
      },
    );
  }
}