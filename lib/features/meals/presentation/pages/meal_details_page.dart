import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/route_names.dart';

class MealDetailsPage extends StatelessWidget {
  final String userId;
  final String mealId;

  const MealDetailsPage({Key? key, required this.userId, required this.mealId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: _mealContent(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/meals/$mealId/edit');
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _mealContent(BuildContext context) {
    return Center(
      child: Text('Meal ID: $mealId'),
    );
  }
}