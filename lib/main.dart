import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/core/routing/app_router.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth_form/auth_form_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/email_verification/email_verification_bloc.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_details/food_details_bloc.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_search/food_search_bloc.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meal_details/meal_details_bloc.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meals/meals_bloc.dart';
import 'package:trepi_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await configureDependencies();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if (const bool.fromEnvironment('dart.vm.product') == false) {
  //   await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => getIt<AuthenticationBloc>(),
        ),
        BlocProvider<FormBloc>(
          create: (context) => getIt<FormBloc>(),
        ),
        BlocProvider<FoodSearchBloc>(
          create: (context) => getIt<FoodSearchBloc>(),
        ),
        BlocProvider<FoodDetailsBloc>(
          create: (context) => getIt<FoodDetailsBloc>(),
        ),
        BlocProvider<MealsBloc>(
          create: (context) => getIt<MealsBloc>(),
        ),
        BlocProvider<MealDetailsBloc>(
          create: (context) => getIt<MealDetailsBloc>(),
        ),
        BlocProvider<EmailVerificationBloc>(
          create: (context) => getIt<EmailVerificationBloc>(),
        ),
        
      ],
      child: MaterialApp.router(
        title: 'Trepi App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}