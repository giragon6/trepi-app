import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/core/routing/route_names.dart';
import 'package:trepi_app/features/meals/domain/entities/meal.dart';
import 'package:trepi_app/features/meals/domain/entities/meal_food.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meal_details/meal_details_bloc.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meals/meals_bloc.dart';
import 'package:trepi_app/shared/widgets/food_search/food_search_selectable_widget.dart';

class EditMealPage extends StatefulWidget {
  final String userId;
  final String? mealId;
  final bool isNewMeal;

  const EditMealPage({
    Key? key,
    required this.userId,
    this.mealId,
    required this.isNewMeal,
  }) : super(key: key);

  @override
  State<EditMealPage> createState() => _EditMealPageState();
}

class _EditMealPageState extends State<EditMealPage> {
  late final MealDetailsBloc _mealDetailsBloc;
  late final MealsBloc _mealsBloc;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  Meal _currentMeal = Meal(
    id: '',
    name: '',
    foods: [],
    totalGrams: 0.0,
    carbGrams: 0.0,
    fatGrams: 0.0,
    proteinGrams: 0.0,
    nutrientProfile: {},
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _mealDetailsBloc = getIt<MealDetailsBloc>();
    _mealsBloc = getIt<MealsBloc>();
    
    if (!widget.isNewMeal && widget.mealId != null) {
      _mealDetailsBloc.add(GetMealDetailsEvent(widget.userId, widget.mealId!));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _populateForm(Meal meal) {
    setState(() {
      _nameController.text = meal.name;
      _currentMeal = Meal(
        id: meal.id,
        name: meal.name,
        foods: meal.foods, 
        totalGrams: meal.totalGrams,
        carbGrams: meal.carbGrams,
        fatGrams: meal.fatGrams,
        proteinGrams: meal.proteinGrams,
        nutrientProfile: Map.from(meal.nutrientProfile),
        createdAt: meal.createdAt,
        updatedAt: meal.updatedAt,
      );
    });
  }

  void _onFoodsSelected(List<MealFood> foods) {
    setState(() {
      _currentMeal = Meal(
        id: _currentMeal.id,
        name: _currentMeal.name,
        foods: foods,
        totalGrams: _currentMeal.totalGrams,
        carbGrams: _currentMeal.carbGrams,
        fatGrams: _currentMeal.fatGrams,
        proteinGrams: _currentMeal.proteinGrams,
        nutrientProfile: _currentMeal.nutrientProfile,
        createdAt: _currentMeal.createdAt,
        updatedAt: _currentMeal.updatedAt,
      );
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final currentFoods = _currentMeal.foods;
    debugPrint('Current Foods: ${currentFoods.toString()}');

    if (currentFoods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one food to the meal')),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a meal name')),
      );
      return;
    }

    final totalGrams = currentFoods.fold(0.0, (sum, food) => sum + food.quantity);
    final carbGrams = currentFoods.fold(0.0, (sum, food) => sum + food.carbGrams);
    final fatGrams = currentFoods.fold(0.0, (sum, food) => sum + food.fatGrams);
    final proteinGrams = currentFoods.fold(0.0, (sum, food) => sum + food.proteinGrams);

    final meal = Meal(
      id: widget.isNewMeal ? '' : widget.mealId!,
      name: _nameController.text.trim(),
      foods: currentFoods,
      totalGrams: totalGrams,
      carbGrams: carbGrams,
      fatGrams: fatGrams,
      proteinGrams: proteinGrams,
      nutrientProfile: _currentMeal.nutrientProfile,
      createdAt: _currentMeal.createdAt,
      updatedAt: DateTime.now(),
    );

    if (widget.isNewMeal) {
      _mealsBloc.add(AddMealEvent(widget.userId, meal));
    } else {
      _mealDetailsBloc.add(UpdateMealDetailsEvent(widget.userId, meal));
    }
  }

  void _showDeleteConfirmation() {
    if (widget.isNewMeal || widget.mealId == null) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Meal'),
          content: Text(
            'Are you sure you want to delete "${_nameController.text}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.pop();
                context.replace(RouteNames.meals);
                _mealsBloc.add(DeleteMealEvent(widget.userId, widget.mealId!));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFoodSearchWidget() => FoodSearchSelectableWidget(
    onFoodsSelected: _onFoodsSelected,
    initialSelectedFoods: _currentMeal.foods,
  );

  Widget _mealForm(BuildContext context, MealDetailsState detailsState) {
    return 
      Form(
        key: _formKey,
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isNewMeal ? 'Add New Meal' : 'Edit Meal Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Meal Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a meal name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildFoodSearchWidget(),
                    const SizedBox(height: 24),
                    BlocBuilder<MealsBloc, MealsState>(
                      builder: (context, mealsState) {
                        final isLoading = mealsState is MealsLoadingState ||
                            detailsState is MealDetailsLoadingState;
                        
                        return ElevatedButton(
                          onPressed: isLoading ? null : _submitForm,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(widget.isNewMeal ? 'Add Meal' : 'Update Meal'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (!widget.isNewMeal) ...[
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delete Forever?',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Deleting a meal is irreversible.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _showDeleteConfirmation,
                        icon: const Icon(Icons.delete_forever, color: Colors.red),
                        label: const Text(
                          'Delete Meal',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        )),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNewMeal ? 'Add New Meal' : 'Edit Meal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:
        MultiBlocListener(
          listeners: [
            BlocListener<MealDetailsBloc, MealDetailsState>(
              listener: (context, state) {
                if (state is MealDetailsLoadedState) {
                  _populateForm(state.meal);
                } else if (state is MealDetailsErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error loading meal: ${state.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            BlocListener<MealsBloc, MealsState>(
              listener: (context, state) {
                if (state is MealsLoadedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.isNewMeal 
                        ? 'Meal added successfully!' 
                        : 'Meal updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.pop();
                } else if (state is MealsErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<MealDetailsBloc, MealDetailsState>(
            builder: (context, detailsState) {
              if (!widget.isNewMeal && detailsState is MealDetailsLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              return _mealForm(context, detailsState);
            },
          ),
        ),
      );
  }
}
