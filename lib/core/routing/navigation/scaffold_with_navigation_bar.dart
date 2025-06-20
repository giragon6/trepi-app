
import 'package:flutter/material.dart';
import 'package:trepi_app/core/routing/navigation/adaptive_scaffold.dart';

class ScaffoldWithNavigationBar extends StatelessWidget {
  final List<AdaptiveScaffoldDestination> destinations;
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget trailing;

  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.trailing = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        destinations: [...destinations.map((destination) {
          return NavigationDestination(
            icon: destination.icon,
            label: destination.label,
          );
        }),
        trailing],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}