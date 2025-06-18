import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_details/food_details_bloc.dart';
import 'package:trepi_app/shared/widgets/food_display/food_display_widget.dart';

class FoodLookupPage extends StatefulWidget {
  const FoodLookupPage({super.key});

  @override
  State<FoodLookupPage> createState() => _FoodLookupPageState();
}

class _FoodLookupPageState extends State<FoodLookupPage> {
  final _controller = TextEditingController();
  late final FoodDetailsBloc _foodBloc;

  @override
  void initState() {
    super.initState();
    _foodBloc = getIt<FoodDetailsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _foodBloc,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'NEST (the backend host for trepi) IS DOWN for reasons out of my control! Please do not review until it is back online :)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
              child: BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
                bloc: _foodBloc, 
                builder: (context, state) {
                  if (state is FoodDetailsInitialState) {
                    return const Center(child: Text('Enter an FDC ID to search'));
                  }
                  if (state is FoodDetailsLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is FoodDetailsLoadedState) {
                    return FoodDisplayWidget(
                      foodDetails: state.foodDetails,
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