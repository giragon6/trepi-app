import 'package:flutter/material.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';
import 'package:trepi_app/shared/widgets/food_search/food_search_widget.dart';

class FoodSearchPage extends StatelessWidget {
  const FoodSearchPage({super.key});

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
            backgroundColor: TrepiColor.green,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Food Search',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [TrepiColor.green, TrepiColor.brown],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.search,
                    size: 60,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              color: TrepiColor.white,
              child: const FoodSearchWidget(),
            ),
          ),
        ],
      ),
    );
  }
}