import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_bloc.dart';
import 'package:trepi_app/shared/widgets/food_display_widget.dart';

class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({super.key});

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  final _controller = TextEditingController();
  late final FoodBloc _foodBloc;

  @override
  void initState() {
    super.initState();
    _foodBloc = getIt<FoodBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _foodBloc,
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
                  _foodBloc.add(GetFoodDetailsEvent(fdcId));
                }
              },
              child: const Text('Search Food'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<FoodBloc, FoodState>(
                bloc: _foodBloc, 
                builder: (context, state) {
                  if (state is FoodInitialState) {
                    return const Center(child: Text('Enter an FDC ID to search'));
                  }
                  if (state is FoodLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is FoodLoadedState) {
                    return FoodDisplayWidget(
                      foodDetails: state.foodDetails,
                    );
                  }
                  if (state is FoodErrorState) {
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
    _foodBloc.close(); 
    _controller.dispose();
    super.dispose();
  }
}