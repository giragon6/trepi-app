import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/navigation/adaptive_scaffold.dart';
import 'package:trepi_app/features/authentication/presentation/pages/authentication_page.dart';
import 'package:trepi_app/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_details_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_lookup_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_search_page.dart';
import 'package:trepi_app/features/home/presentation/pages/home_page.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.home,
  routes: [
    ..._authBranches,

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AdaptiveScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.home,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomePage()
              )
            )
          ]
        ),
        ..._foodSearchBranches,
      ]
    ),
    
    GoRoute(
    path: RouteNames.foodDetailsWithParam,
    pageBuilder: (context, state) {
      final fdcId = state.pathParameters['fdcId'];
      if (fdcId == null) {
        return const NoTransitionPage(
          child: FoodSearchPage() // Fallback page if fdcId is not provided
        );
      }
      return NoTransitionPage(
        child: FoodDetailsPage(fdcId: fdcId)
      );
    }
    ),
    ]
  );

final List<GoRoute> _authBranches = [
  GoRoute(
    path: RouteNames.auth,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: AuthenticationPage()
    )
  ),
  GoRoute(
    path: RouteNames.signIn,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: SignUpPage() // Placeholder for SignInPage
    )
  ),
  GoRoute(
    path: RouteNames.register,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: SignUpPage() // Placeholder for RegisterPage
    )
  )
];

final List<StatefulShellBranch> _foodSearchBranches = [
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
];