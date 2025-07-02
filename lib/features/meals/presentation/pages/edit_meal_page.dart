import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/core/routing/route_names.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';
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
    super.key,
    required this.userId,
    this.mealId,
    required this.isNewMeal,
  });

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
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: TrepiColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.red.shade700,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Delete Meal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: TrepiColor.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete "${_nameController.text}"?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: TrepiColor.brown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: TrepiColor.brown.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: TrepiColor.brown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context.replace(RouteNames.meals);
                          _mealsBloc.add(DeleteMealEvent(widget.userId, widget.mealId!));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFoodSearchWidget() => FoodSearchSelectableWidget(
    onFoodsSelected: _onFoodsSelected,
    initialSelectedFoods: _currentMeal.foods,
  );

  Widget _mealForm(BuildContext context, MealDetailsState detailsState) {
    return Container(
      decoration: BoxDecoration(
        color: TrepiColor.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Meal Details Card
              Container(
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
                          Text(
                            'Meal Information',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: TrepiColor.brown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: TrepiColor.brown),
                        decoration: InputDecoration(
                          labelText: 'Meal Name',
                          labelStyle: const TextStyle(color: TrepiColor.brown),
                          hintText: 'Enter a name for your meal',
                          hintStyle: TextStyle(color: TrepiColor.brown.withValues(alpha: 0.6)),
                          prefixIcon: const Icon(Icons.edit, color: TrepiColor.orange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: TrepiColor.brown.withValues(alpha: 0.3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: TrepiColor.brown.withValues(alpha: 0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: TrepiColor.orange, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red, width: 2),
                          ),
                          filled: true,
                          fillColor: TrepiColor.white,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a meal name';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Food Selection Card
              Container(
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
                              color: TrepiColor.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: TrepiColor.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Add Foods',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: TrepiColor.brown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildFoodSearchWidget(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              BlocBuilder<MealsBloc, MealsState>(
                builder: (context, mealsState) {
                  final isLoading = mealsState is MealsLoadingState ||
                      detailsState is MealDetailsLoadingState;
                  
                  return Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isLoading 
                          ? [Colors.grey.shade300, Colors.grey.shade400]
                          : [TrepiColor.orange, TrepiColor.orange.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isLoading ? Colors.grey : TrepiColor.orange).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Processing...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.isNewMeal ? Icons.add : Icons.save,
                                  color: TrepiColor.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.isNewMeal ? 'Add Meal' : 'Update Meal',
                                  style: const TextStyle(
                                    color: TrepiColor.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
              
              // Delete Section (for editing existing meals)
              if (!widget.isNewMeal) ...[
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade200),
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
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.warning_amber,
                                color: Colors.red.shade700,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Danger Zone',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Deleting a meal is permanent and cannot be undone.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _showDeleteConfirmation,
                            icon: Icon(Icons.delete_forever, color: Colors.red.shade700),
                            label: Text(
                              'Delete Meal Forever',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red.shade300, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                widget.isNewMeal ? 'Add New Meal' : 'Edit Meal',
                style: const TextStyle(
                  color: TrepiColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            backgroundColor: TrepiColor.orange,
            foregroundColor: TrepiColor.white,
            actions: [
              if (!widget.isNewMeal)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _showDeleteConfirmation,
                  tooltip: 'Delete Meal',
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: MultiBlocListener(
              listeners: [
                BlocListener<MealDetailsBloc, MealDetailsState>(
                  listener: (context, state) {
                    if (state is MealDetailsLoadedState) {
                      _populateForm(state.meal);
                    } else if (state is MealDetailsErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text('Error loading meal: ${state.error}'),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.red.shade700,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(widget.isNewMeal 
                                ? 'Meal added successfully!' 
                                : 'Meal updated successfully!'),
                            ],
                          ),
                          backgroundColor: TrepiColor.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                      context.pop();
                    } else if (state is MealsErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text('Error: ${state.message.toString()}'),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.red.shade700,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<MealDetailsBloc, MealDetailsState>(
                builder: (context, detailsState) {
                  if (!widget.isNewMeal && detailsState is MealDetailsLoadingState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        color: TrepiColor.white,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                      ),
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
                  }

                  return _mealForm(context, detailsState);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
