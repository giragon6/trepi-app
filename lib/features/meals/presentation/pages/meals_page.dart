import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/route_names.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart'; // For userId
import 'package:trepi_app/features/meals/presentation/bloc/meal_details/meal_details_bloc.dart';
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
      debugPrint("MealsPage: User not authenticated or UID not available to fetch meals.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Meals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push(RouteNames.addMeal);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final authState = context.read<AuthenticationBloc>().state;
              if (authState is AuthenticationLoadedState) {
                context.read<MealsBloc>().add(GetMealsEvent(authState.user.uid));
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<MealsBloc, MealsState>(
        builder: (context, state) {
          if (state is MealsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MealsLoadedState) {
            if (state.meals.isEmpty) {
              return const Center(child: Text('No meals found. Add one!'));
            }
            return ListView.builder(
              itemCount: state.meals.length,
              itemBuilder: (context, index) {
                final meal = state.meals[index];
                return ListTile(
                  title: Text(meal.name),
                  onTap: () {
                    final authState = context.read<AuthenticationBloc>().state;
                    if (authState is! AuthenticationLoadedState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please sign in to view meal details.')),
                      );
                      return;
                    }
                    context.push(
                      '${RouteNames.meals}/${meal.id}',
                      extra: meal,
                    );
                  },
                );
              },
            );
          } else if (state is MealsErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('Unexpected state: ${state.runtimeType}')); 
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouteNames.addMeal);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}