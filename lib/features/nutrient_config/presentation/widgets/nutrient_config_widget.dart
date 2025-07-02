import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/core/styles/trepi_color.dart';
import 'package:trepi_app/features/nutrient_config/presentation/bloc/nutrient_config_bloc.dart';

class NutrientConfigWidget extends StatefulWidget {
  const NutrientConfigWidget({super.key});

  @override
  State<NutrientConfigWidget> createState() => _NutrientConfigWidgetState();
}

class _NutrientConfigWidgetState extends State<NutrientConfigWidget> {
  List<int>? _initialSelectedIds;
  bool _showSavedConfirmation = false;

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
        if (state is NutrientConfigLoadedState) {
          final selectedIds = state.selectedNutrients
              .where((n) => n.isSelected)
              .map((n) => n.id)
              .toList();
          if (_showSavedConfirmation) {
            _initialSelectedIds = List<int>.from(selectedIds);
            setState(() {
              _showSavedConfirmation = false;
            });
          }
          _initialSelectedIds ??= List<int>.from(selectedIds);
        }
      },
      builder: (context, state) {
        if (state is NutrientConfigLoadedState) {
          final selectedIds = state.selectedNutrients
              .where((n) => n.isSelected)
              .map((n) => n.id)
              .toList();
          final showSave = _initialSelectedIds != null && !_listEquals(selectedIds, _initialSelectedIds!);
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 72),
                child: _buildNutrientSelectionSection(context, state),
              ),
              if (showSave)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: Center(
                    child: SizedBox(
                      width: 180,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showSavedConfirmation = true;
                          });
                          context.read<NutrientConfigBloc>().add(
                            NutrientConfigSaveEvent(selectedNutrientIds: selectedIds),
                          );
                        },
                        icon: const Icon(Icons.save, color: TrepiColor.white),
                        label: const Text(
                          'Save',
                          style: TextStyle(
                            color: TrepiColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TrepiColor.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        } else if (state is NutrientConfigErrorState) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    final aSorted = List<int>.from(a)..sort();
    final bSorted = List<int>.from(b)..sort();
    for (int i = 0; i < aSorted.length; i++) {
      if (aSorted[i] != bSorted[i]) return false;
    }
    return true;
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
              itemCount: state.selectedNutrients.length,
              itemBuilder: (context, index) {
                final nutrient = state.selectedNutrients[index];
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