import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/route_names.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meals/meals_bloc.dart';

class MealsPage extends StatefulWidget {
  const MealsPage({super.key});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationLoadedState) {
      context.read<MealsBloc>().add(GetMealsEvent(authState.user.uid));
    } else {
      Center(child: Text('Sign in to create meals!'));
    }
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
              title: const Text(
                'My Meals',
                style: TextStyle(
                  color: TrepiColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            backgroundColor: TrepiColor.orange,
            foregroundColor: TrepiColor.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  final authState = context.read<AuthenticationBloc>().state;
                  if (authState is AuthenticationLoadedState) {
                    context.read<MealsBloc>().add(GetMealsEvent(authState.user.uid));
                  }
                },
                tooltip: 'Refresh',
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  context.push(RouteNames.addMeal);
                },
                tooltip: 'Add New Meal',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: TrepiColor.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: BlocBuilder<MealsBloc, MealsState>(
                builder: (context, state) {
                  if (state is MealsLoadingState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(TrepiColor.orange),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading your meals...',
                              style: TextStyle(
                                color: TrepiColor.brown,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is MealsLoadedState) {
                    if (state.meals.isEmpty) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: TrepiColor.orange.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.restaurant_menu,
                                  size: 64,
                                  color: TrepiColor.orange,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No meals yet',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: TrepiColor.brown,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Create your first meal to start tracking your nutrition',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: TrepiColor.brown.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [TrepiColor.orange, TrepiColor.orange.withValues(alpha: 0.8)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TrepiColor.orange.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () => context.push(RouteNames.addMeal),
                                  icon: const Icon(Icons.add, color: TrepiColor.white),
                                  label: const Text(
                                    'Create Your First Meal',
                                    style: TextStyle(
                                      color: TrepiColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    return Padding(
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
                                  Icons.restaurant,
                                  color: TrepiColor.green,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${state.meals.length} Meal${state.meals.length == 1 ? '' : 's'}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: TrepiColor.brown,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.meals.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final meal = state.meals[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TrepiColor.brown.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      final authState = context.read<AuthenticationBloc>().state;
                                      if (authState is! AuthenticationLoadedState) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(Icons.warning, color: Colors.white),
                                                const SizedBox(width: 8),
                                                const Text('Please sign in to view meal details.'),
                                              ],
                                            ),
                                            backgroundColor: Colors.orange.shade700,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      context.push(
                                        '${RouteNames.meals}/${meal.id}',
                                        extra: meal,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: TrepiColor.orange.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                              Icons.restaurant_menu,
                                              color: TrepiColor.orange,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  meal.name,
                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: TrepiColor.brown,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${meal.foods.length} food${meal.foods.length == 1 ? '' : 's'} • ${meal.totalGrams.toStringAsFixed(0)}g total',
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: TrepiColor.brown.withValues(alpha: 0.7),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    _buildMacroChip('P', meal.proteinGrams, TrepiColor.green),
                                                    const SizedBox(width: 8),
                                                    _buildMacroChip('C', meal.carbGrams, TrepiColor.orange),
                                                    const SizedBox(width: 8),
                                                    _buildMacroChip('F', meal.fatGrams, TrepiColor.brown),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: TrepiColor.brown.withValues(alpha: 0.5),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 80), // Padding for FAB
                        ],
                      ),
                    );
                  } else if (state is MealsErrorState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red.shade700,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Oops! Something went wrong',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: TrepiColor.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: TrepiColor.brown.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                final authState = context.read<AuthenticationBloc>().state;
                                if (authState is AuthenticationLoadedState) {
                                  context.read<MealsBloc>().add(GetMealsEvent(authState.user.uid));
                                }
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TrepiColor.orange,
                                foregroundColor: TrepiColor.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Text(
                        'Unexpected state: ${state.runtimeType}',
                        style: TextStyle(color: TrepiColor.brown),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [TrepiColor.orange, TrepiColor.orange.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: TrepiColor.orange.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => context.push(RouteNames.addMeal),
          elevation: 1,
          icon: const Icon(Icons.add),
          label: const Text(
            'Add Meal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMacroChip(String label, double grams, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: ${grams.toStringAsFixed(0)}g',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}