import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/core/routing/navigation/adaptive_scaffold.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/pages/authentication_page.dart';
import 'package:trepi_app/features/authentication/presentation/pages/profile_page.dart';
import 'package:trepi_app/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:trepi_app/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_details_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_lookup_page.dart';
import 'package:trepi_app/features/food_search/presentation/pages/food_search_page.dart';
import 'package:trepi_app/features/home/presentation/pages/home_page.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.auth,
  debugLogDiagnostics: true,
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
        StatefulShellBranch(
          routes: [
              GoRoute(
                path: RouteNames.profile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfilePage()
                )
              ),
          ]
        ),
      ]
    ),
    
    GoRoute(
    path: RouteNames.foodDetailsWithParam,
    pageBuilder: (context, state) {
      final fdcId = state.pathParameters['fdcId'];
      if (fdcId == null) {
        return const NoTransitionPage(
          child: FoodSearchPage() 
        );
      }
      return NoTransitionPage(
        child: FoodDetailsPage(fdcId: fdcId)
      );
    }
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthenticationBloc>();
    final currentAuthState = authBloc.state;

    final loggingIn = state.matchedLocation == RouteNames.signIn ||
                      state.matchedLocation == RouteNames.signUp ||
                      state.matchedLocation == RouteNames.auth;

    if (currentAuthState is AuthenticationLoadedState) {
      if (loggingIn) {
        debugPrint('[Router Redirect] User authenticated, was on auth page, redirecting to home.');
        return RouteNames.home;
      }
      debugPrint('[Router Redirect] User authenticated, not on auth page, no redirect.');
      return null;
    }

    if (currentAuthState is AuthenticationSignedOutState ||
        currentAuthState is AuthenticationErrorState ||
        currentAuthState is AuthenticationInitialState) {
      if (!loggingIn) {
        debugPrint('[Router Redirect] User not authenticated, was on protected page, redirecting to sign-in.');
        return RouteNames.signIn;
      }
      debugPrint('[Router Redirect] User not authenticated, on auth page, no redirect.');
      return null;
    }
    
    if (currentAuthState is AuthenticationLoadingState && state.matchedLocation != RouteNames.auth) {
        debugPrint('[Router Redirect] Auth loading, redirecting to auth page.');
        return RouteNames.auth;
    }
    
    debugPrint('[Router Redirect] No redirect condition met for state: ${currentAuthState.runtimeType} at ${state.matchedLocation}');
    return null; 
  },
  refreshListenable: GoRouterRefreshStream(getIt<AuthenticationBloc>().stream),
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

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
      child: SignInPage() 
    )
  ),
  GoRoute(
    path: RouteNames.signUp,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: SignUpPage() 
    )
  ),
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