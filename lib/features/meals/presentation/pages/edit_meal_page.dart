import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/features/meals/domain/entities/meal.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meal_details/meal_details_bloc.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meals/meals_bloc.dart';

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
  final _totalGramsController = TextEditingController();
  final _carbGramsController = TextEditingController();
  final _fatGramsController = TextEditingController();
  final _proteinGramsController = TextEditingController();

  Meal? _currentMeal;

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
    _totalGramsController.dispose();
    _carbGramsController.dispose();
    _fatGramsController.dispose();
    _proteinGramsController.dispose();
    _mealDetailsBloc.close();
    super.dispose();
  }

  void _populateForm(Meal meal) {
    _nameController.text = meal.name;
    _totalGramsController.text = meal.totalGrams.toString();
    _carbGramsController.text = meal.carbGrams.toString();
    _fatGramsController.text = meal.fatGrams.toString();
    _proteinGramsController.text = meal.proteinGrams.toString();
    _currentMeal = meal;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final meal = Meal(
      id: widget.isNewMeal ? '' : widget.mealId!,
      name: _nameController.text.trim(),
      foods: _currentMeal?.foods ?? [],
      totalGrams: double.tryParse(_totalGramsController.text) ?? 0.0,
      carbGrams: double.tryParse(_carbGramsController.text) ?? 0.0,
      fatGrams: double.tryParse(_fatGramsController.text) ?? 0.0,
      proteinGrams: double.tryParse(_proteinGramsController.text) ?? 0.0,
      nutrientProfile: _currentMeal?.nutrientProfile ?? {},
      createdAt: _currentMeal?.createdAt,
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
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNewMeal ? 'Add New Meal' : 'Edit Meal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _mealDetailsBloc),
          BlocProvider.value(value: _mealsBloc),
        ],
        child: MultiBlocListener(
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

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
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
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _totalGramsController,
                                decoration: const InputDecoration(
                                  labelText: 'Total Grams',
                                  border: OutlineInputBorder(),
                                  suffixText: 'g',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter total grams';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _carbGramsController,
                                      decoration: const InputDecoration(
                                        labelText: 'Carbs',
                                        border: OutlineInputBorder(),
                                        suffixText: 'g',
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value != null && value.isNotEmpty &&
                                            double.tryParse(value) == null) {
                                          return 'Invalid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _fatGramsController,
                                      decoration: const InputDecoration(
                                        labelText: 'Fat',
                                        border: OutlineInputBorder(),
                                        suffixText: 'g',
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value != null && value.isNotEmpty &&
                                            double.tryParse(value) == null) {
                                          return 'Invalid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _proteinGramsController,
                                      decoration: const InputDecoration(
                                        labelText: 'Protein',
                                        border: OutlineInputBorder(),
                                        suffixText: 'g',
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value != null && value.isNotEmpty &&
                                            double.tryParse(value) == null) {
                                          return 'Invalid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                                  'Danger Zone',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Once you delete a meal, there is no going back. Please be certain.',
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
