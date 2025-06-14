import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_details/food_details_bloc.dart';
import 'package:trepi_app/shared/widgets/food_display/food_display_widget.dart';

class FoodDetailsPage extends StatefulWidget {
  final String fdcId;
  
  const FoodDetailsPage({
    super.key,
    required this.fdcId,
  });

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  late final FoodDetailsBloc _foodDetailsBloc;

  @override
  void initState() {
    super.initState();
    _foodDetailsBloc = getIt<FoodDetailsBloc>();
    final fdcId = int.tryParse(widget.fdcId);
    if (fdcId != null) {
      _foodDetailsBloc.add(GetFoodDetailsEvent(fdcId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Food Details'),
      ),
      body: BlocProvider.value(
        value: _foodDetailsBloc,
        child: BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
          builder: (context, state) {
            if (state is FoodDetailsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FoodDetailsLoadedState) {
              return FoodDisplayWidget(
                foodDetails: state.foodDetails,
              );
            }
            if (state is FoodDetailsErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.error}'),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Loading...'));
          },
        ),
      ),
    );
  }
}