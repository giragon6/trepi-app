import 'package:go_router/go_router.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_details_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_lookup_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_search_page.dart';
import 'package:trepi_app/main.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => const HomePage(title: "Trepi App"), 
    ),
    GoRoute(
      path: RouteNames.foodSearch,
      builder: (context, state) => const FoodSearchPage(),
    ),
    GoRoute(
      path: RouteNames.foodLookup,
      builder: (context, state) => const FoodLookupPage(),
    ),
    GoRoute(
      path: RouteNames.foodDetails,
      builder: (context, state) {
        final fdcId = state.pathParameters['fdcId']!;
        return FoodDetailsPage(fdcId: fdcId);
      },
    ),
  ],
);