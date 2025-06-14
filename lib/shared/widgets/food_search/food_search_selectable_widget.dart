import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/features/food_search/domain/entities/food_details.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_details/food_details_bloc.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_search/food_search_bloc.dart';
import 'package:trepi_app/features/meals/domain/entities/meal_food.dart';
import 'package:trepi_app/shared/constants/nutrient_lookup.dart';
import 'package:trepi_app/utils/get_nutrient_amount.dart';
import 'package:trepi_app/utils/result.dart';

class FoodSearchSelectableWidget extends StatefulWidget {
  final Function(List<MealFood>) onFoodsSelected;
  final List<MealFood> initialSelectedFoods;

  const FoodSearchSelectableWidget({
    Key? key,
    required this.onFoodsSelected,
    this.initialSelectedFoods = const [],
  }) : super(key: key);

  @override
  State<FoodSearchSelectableWidget> createState() => _FoodSearchSelectableWidgetState();
}

class _FoodSearchSelectableWidgetState extends State<FoodSearchSelectableWidget> {
  final _searchController = TextEditingController();
  late List<MealFood> _selectedFoods;

  double? _pendingQuantity;

  @override
  void initState() {
    super.initState();
    _selectedFoods = List.from(widget.initialSelectedFoods);
  }

  void _handleFoodDetailsLoaded(FoodDetails food) {
    if (_pendingQuantity == null) return;
    
    final proteinGramsResult = getNutrientAmount(Macro.protein.id, food);
    final carbGramsResult = getNutrientAmount(Macro.carbohydrate.id, food);
    final fatGramsResult = getNutrientAmount(Macro.fat.id, food);

    // measurements are per 100g
    final proteinGrams = proteinGramsResult is Ok<double>
      ? proteinGramsResult.value
      : 0.0;
    final carbGrams = carbGramsResult is Ok<double>
      ? carbGramsResult.value
      : 0.0;
    final fatGrams = fatGramsResult is Ok<double>
      ? fatGramsResult.value
      : 0.0; 

    final mealFood = MealFood(
      fdcId: food.fdcId,
      description: food.itemDescription ?? '',
      quantity: _pendingQuantity ?? 0.0,
      proteinGrams: proteinGrams * _pendingQuantity! / 100.0,
      carbGrams: carbGrams* _pendingQuantity! / 100.0,
      fatGrams: fatGrams * _pendingQuantity! / 100.0,
    );
    
    setState(() {
      _selectedFoods.add(mealFood);
    });
    
    widget.onFoodsSelected(_selectedFoods);
    
    _pendingQuantity = null;
  }

  void _addFood(int fdcId, double quantity) {
    _pendingQuantity = quantity;

    context.read<FoodDetailsBloc>().add(GetFoodDetailsEvent(fdcId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodDetailsBloc, FoodDetailsState>(
      listener: (context, state) {
        if (state is FoodDetailsLoadedState) {
          _handleFoodDetailsLoaded(state.foodDetails);
        } else if (state is FoodDetailsErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading food details: ${state.error}')),
          );
        }
      },
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search foods...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final name = _searchController.text.trim();
              if (name.isNotEmpty) {
                context.read<FoodSearchBloc>().add(GetFoodSearchEvent(name, 10, 1));
              }
            },
            child: const Text('Search Food'),
          ),
          
          BlocBuilder<FoodSearchBloc, FoodSearchState>(
            builder: (context, state) {
              if (_searchController.text.isEmpty) {
                return const Center(child: Text('Enter a food name to search the FDC database'));
              }
              if (state is FoodSearchLoadingState) {
                return const CircularProgressIndicator();
              } else if (state is FoodSearchLoadedState) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.foodResults.length,
                  itemBuilder: (context, index) {
                    final food = state.foodResults[index];
                    return SelectableFoodWidget(
                      fdcId: food.fdcId, 
                      name: food.itemDescription,
                      onAdd: _addFood
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          if (_selectedFoods.isNotEmpty)
            SelectedFoodsWidget(
              foods: _selectedFoods,
              onRemove: (index) {
                setState(() {
                  _selectedFoods.removeAt(index);
                });
                widget.onFoodsSelected(_selectedFoods);
              },
            ),
        ],
      ),
    );
  }
}

class SelectableFoodWidget extends StatelessWidget {
  final String name;
  final int fdcId;
  final Function(int fdcId, double quantity) onAdd;

  const SelectableFoodWidget({
    Key? key,
    required this.name,
    required this.fdcId,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('FDC ID: $fdcId'),
      trailing: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Enter Quantity'),
                content: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Quantity in grams'),
                  onSubmitted: (value) {
                    final quantity = double.tryParse(value);
                    if (quantity != null && quantity > 0) {
                      onAdd(fdcId, quantity);
                      context.pop();
                    }
                  },
                ),
              );
            },
          );
        },
        child: const Text('Add'),
      ),
    );
  }
}

class SelectedFoodsWidget extends StatelessWidget {
  final List<MealFood> foods;
  final Function(int index) onRemove;

  const SelectedFoodsWidget({
    Key? key,
    required this.foods,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Selected Foods:', style: TextStyle(fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return ListTile(
              title: Text('${food.description} (${food.quantity}g)'),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () => onRemove(index),
              ),
            );
          },
        ),
      ],
    );
  }
}