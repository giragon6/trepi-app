import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/core/injection/injection.dart';
import 'package:trepi_app/core/routing/app_router.dart';
import 'package:trepi_app/core/styles/trepi_theme.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth_form/auth_form_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/email_verification/email_verification_bloc.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_details/food_details_bloc.dart';
import 'package:trepi_app/features/food_search/presentation/bloc/food_search/food_search_bloc.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meal_details/meal_details_bloc.dart';
import 'package:trepi_app/features/meals/presentation/bloc/meals/meals_bloc.dart';
import 'package:trepi_app/features/nutrient_config/presentation/bloc/nutrient_config_bloc.dart';
import 'package:trepi_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await configureDependencies();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (const bool.fromEnvironment('dart.vm.product') == false) {
    try {
     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
   } catch (e) {
     debugPrint(e.toString());
   }
  }
  
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
          create: (context) {
            getIt<EmailVerificationBloc>().add(EmailVerificationCheckEvent());
            return getIt<EmailVerificationBloc>();
          },
        ),
        BlocProvider<NutrientConfigBloc>(
          create: (context) {
            return getIt<NutrientConfigBloc>();
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Trepi App',
        theme: trepiTheme,
        routerConfig: appRouter,
      ),
    );
  }
}