import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/navigation/scaffold_with_navigation_bar.dart';
import 'package:trepi_app/core/routing/navigation/scaffold_with_navigation_rail.dart';
import 'package:trepi_app/core/routing/route_names.dart';
import 'package:trepi_app/features/authentication/presentation/widgets/auth_image/auth_image_widget.dart';

enum ScreenSize {
  small(pixels: 0),
  medium(pixels: 450),
  large(pixels: 800);

  const ScreenSize({required this.pixels});

  final double pixels;
}

class AdaptiveScaffoldDestination {
  final String label;
  final Icon icon;
  final String location;

  const AdaptiveScaffoldDestination({
    required this.label,
    required this.icon,
    required this.location,
  });
}

class AdaptiveScaffold extends StatelessWidget {
  final List<AdaptiveScaffoldDestination> destinations = const [
    AdaptiveScaffoldDestination(
      label: 'Home', 
      icon: Icon(Icons.home), 
      location: RouteNames.home
    ),
    AdaptiveScaffoldDestination(
      label: 'Food Search',
      icon: Icon(Icons.search),
      location: RouteNames.foodSearch,
    ),
    AdaptiveScaffoldDestination(
      label: 'Food ID Lookup',
      icon: Icon(Icons.info),
      location: RouteNames.foodLookup,
    ),
    AdaptiveScaffoldDestination(
      label: 'Meals',
      icon: Icon(Icons.restaurant_menu),
      location: RouteNames.meals,
    ),
  ];

  const AdaptiveScaffold({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) { 
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {

      if (constraints.maxWidth < ScreenSize.medium.pixels) {
        return ScaffoldWithNavigationBar(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
          destinations: destinations
        );
      } else {
        return ScaffoldWithNavigationRail(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
          destinations: destinations,
          trailing: Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: AuthImageWidget(
                  onPressed: () => context.push(RouteNames.profile)
                )
              )
            ),
          )
        );
      }
    });
  }
}