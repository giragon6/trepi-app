import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';
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
      backgroundColor: TrepiColor.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: TrepiColor.orange,
            foregroundColor: TrepiColor.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Food Details',
                style: TextStyle(
                  color: TrepiColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [TrepiColor.orange, TrepiColor.brown],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.restaurant_menu,
                    size: 60,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocProvider.value(
              value: _foodDetailsBloc,
              child: BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
                builder: (context, state) {
                  if (state is FoodDetailsLoadingState) {
                    return _buildLoadingView();
                  }
                  if (state is FoodDetailsLoadedState) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FoodDisplayWidget(
                        foodDetails: state.foodDetails,
                      ),
                    );
                  }
                  if (state is FoodDetailsErrorState) {
                    return _buildErrorView(context, state.error);
                  }
                  return _buildLoadingView();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return SizedBox(
      height: 400,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(TrepiColor.orange),
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Loading food details...',
              style: TextStyle(
                fontSize: 16,
                color: TrepiColor.brown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: TrepiColor.brown,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                error,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(
                      'Go Back',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: TrepiColor.brown,
                      side: const BorderSide(color: TrepiColor.brown, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final fdcId = int.tryParse(widget.fdcId);
                      if (fdcId != null) {
                        _foodDetailsBloc.add(GetFoodDetailsEvent(fdcId));
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Retry',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: TrepiColor.orange,
                      foregroundColor: TrepiColor.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
  }
}