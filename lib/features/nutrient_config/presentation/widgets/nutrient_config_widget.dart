import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';
import 'package:trepi_app/features/nutrient_config/presentation/bloc/nutrient_config_bloc.dart';

class NutrientConfigWidget extends StatelessWidget {
  const NutrientConfigWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NutrientConfigBloc, NutrientConfigState>(
      listener: (context, state) {
        debugPrint('NutrientConfigWidget: state changed to $state');
        if (state is NutrientConfigErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        if (state is NutrientConfigLoadedState) {
          return _buildNutrientSelectionSection(context, state);
        } else if (state is NutrientConfigErrorState) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }      

  Widget _buildNutrientSelectionSection(BuildContext context, NutrientConfigLoadedState state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Available Nutrients',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: TrepiColor.brown,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: state.commonNutrients.length,
              itemBuilder: (context, index) {
                final nutrient = state.commonNutrients[index];
                return CheckboxListTile(
                  title: Text(nutrient.name),
                  subtitle: Text('Unit: ${nutrient.unitName}'),
                  value: nutrient.isSelected,
                  onChanged: (_) => context.read<NutrientConfigBloc>().add(
                    NutrientConfigToggleEvent(
                      nutrientId: nutrient.id,
                      isEnabled: !nutrient.isSelected,
                    ),
                  ),
                  activeColor: TrepiColor.green,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
          ),
        ],
    );
  }
}