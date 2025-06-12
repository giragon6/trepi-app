import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/navigation/adaptive_scaffold.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_lookup_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_search_page.dart';
import 'package:trepi_app/features/home/presentation/pages/home_page.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.home,
  routes: [StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AdaptiveScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.home,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomePage(title: 'Trepi App') 
              )
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.foodSearch,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: FoodSearchPage() 
              )
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.foodLookup,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: FoodLookupPage()
              )
            ),
          ]
        ),
      ]
    )]
  );