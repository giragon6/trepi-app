import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_details/food_details_bloc.dart';
import 'package:trepi_app/features/nutrient_config/domain/entities/nutrient_config.dart';
import 'package:trepi_app/features/nutrient_config/presentation/bloc/nutrient_config_bloc.dart';
import 'package:trepi_app/shared/widgets/food_display/food_display_widget.dart';

class FoodLookupPage extends StatefulWidget {
  const FoodLookupPage({super.key});

  @override
  State<FoodLookupPage> createState() => _FoodLookupPageState();
}

class _FoodLookupPageState extends State<FoodLookupPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter FDC ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final fdcId = int.tryParse(_controller.text);
                if (fdcId != null) {
                  BlocProvider.of<FoodDetailsBloc>(context).add(GetFoodDetailsEvent(fdcId));
                }
              },
              child: const Text('Search Food'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
                builder: (context, state) {
                  if (state is FoodDetailsInitialState) {
                    return const Center(child: Text('Enter an FDC ID to search'));
                  }
                  if (state is FoodDetailsLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is FoodDetailsLoadedState) {
                    return FoodDisplayWidget(
                      foodDetails: state.foodDetails
                    );
                  }
                  if (state is FoodDetailsErrorState) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}