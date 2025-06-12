import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/navigation/adaptive_scaffold.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_details_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_lookup_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_search_page.dart';
import 'package:trepi_app/features/home/presentation/pages/home_page.dart';
import 'route_names.dart';

// final GoRouter appRouter = GoRouter(
//   routes: [
//     GoRoute(
//       path: RouteNames.home,
//       builder: (context, state) => const HomePage(title: "Trepi App"), 
//     ),
//     GoRoute(
//       path: RouteNames.foodSearch,
//       builder: (context, state) => const FoodSearchPage(),
//     ),
//     GoRoute(
//       path: RouteNames.foodLookup,
//       builder: (context, state) => const FoodLookupPage(),
//     ),
//     GoRoute(
//       path: RouteNames.foodDetails,
//       builder: (context, state) {
//         final fdcId = state.pathParameters['fdcId']!;
//         return FoodDetailsPage(fdcId: fdcId);
//       },
//     ),
//   ],
// );

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
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.foodDetails,
              redirect: (context, state) => 
                '${RouteNames.foodDetails}/${state.pathParameters['fdcId']}',
              routes: [
                GoRoute(
                  path: ':fdcId',
                  pageBuilder: (context, state) {
                    final fdcId = state.pathParameters['fdcId']!;
                    return NoTransitionPage(
                      child: FoodDetailsPage(fdcId: fdcId)
                    );
                  }
                )
              ]
            )
          ]
        )
      ]
    )]
  );