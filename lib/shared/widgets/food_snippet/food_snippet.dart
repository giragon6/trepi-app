import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FoodSnippetWidget extends StatelessWidget {
  final String foodName;
  final String fdcId;

  const FoodSnippetWidget({
    Key? key,
    required this.foodName,
    required this.fdcId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/food/$fdcId');
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            foodName,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}