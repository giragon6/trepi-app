import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_search/food_search_bloc.dart';
import 'package:trepi_app/shared/widgets/food_snippet/food_snippet.dart';

class FoodSearchWidget extends StatefulWidget {
  const FoodSearchWidget({super.key});

  // TODO: make this more clean (decouple, injection)

  @override
  State<FoodSearchWidget> createState() => _FoodSearchWidgetState();
}

class _FoodSearchWidgetState extends State<FoodSearchWidget> {
  final _controller = TextEditingController();
  late final FoodSearchBloc _foodSearchBloc;

  @override
  void initState() {
    super.initState();
    _foodSearchBloc = getIt<FoodSearchBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FoodSearchBloc>(
      create: (context) => _foodSearchBloc,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter food name',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = _controller.text.trim();
                if (name.isNotEmpty) {
                  _foodSearchBloc.add(GetFoodSearchEvent(name, 10, 1));
                }
              },
              child: const Text('Search Food'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<FoodSearchBloc, FoodSearchState>(
                bloc: _foodSearchBloc, 
                builder: (context, state) {
                  debugPrint('Current FoodSearchState: $state');
                  switch (state) {
                  case FoodSearchInitialState():
                    return const Center(child: Text('Enter a food name to search the FDC database'));

                  case FoodSearchLoadingState():
                    return const Center(child: CircularProgressIndicator());

                  case FoodSearchLoadedState():
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.foodResults.length,
                            itemBuilder: (context, index) {
                              final food = state.foodResults[index];
                              return FoodSnippetWidget(
                                foodName: food.itemDescription,
                                fdcId: food.fdcId.toString(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: state.isFirstPage ? null : () {
                                final name = _controller.text.trim();
                                _foodSearchBloc.add(GetFoodSearchEvent(name, 10, state.pageNumber - 1));
                              }, 
                              child: const Icon(Icons.arrow_back, size: 24),
                            ),
                            Text('Page ${state.pageNumber}'),
                            ElevatedButton(
                              onPressed: state.isLastPage ? null : () {
                                final name = _controller.text.trim();
                                _foodSearchBloc.add(GetFoodSearchEvent(name, 10, state.pageNumber + 1));
                              },
                              child: const Icon(Icons.arrow_forward, size: 24),
                            ),
                          ],
                        ),
                      ],
                    );

                  case FoodSearchErrorState():
                    return Center(child: Text('Error: ${state.error}'));

                  default:
                    debugPrint('Unknown FoodSearchState: $state');
                    return const SizedBox.shrink();
                  }
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