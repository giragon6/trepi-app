import 'package:flutter/material.dart';
import 'package:trepi_app/core/routing/navigation/adaptive_scaffold.dart';

class ScaffoldWithNavigationRail extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveScaffoldDestination> destinations;
  
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: (0 <= selectedIndex && selectedIndex < destinations.length) ? selectedIndex : 0,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: destinations.map((destination) {
              return NavigationRailDestination(
                icon: destination.icon,
                label: Text(destination.label),
              );
            }).toList()
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}