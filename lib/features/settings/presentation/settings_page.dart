import 'package:flutter/material.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';
import 'package:trepi_app/features/nutrient_config/presentation/widgets/nutrient_config_widget.dart';

class SettingsPage extends StatelessWidget {
  @override
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: TrepiColor.orange,
      ),
      body: NutrientConfigWidget()
    );
  }
}