import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/route_names.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: 
      (context, state) {
        switch (state) {
          case AuthenticationSignedOutState():
            return Center(child: ElevatedButton(onPressed: () => { context.push(RouteNames.signIn) }, child: Text('Sign In')));
          case AuthenticationErrorState():
            return Center(child: Text('Error: ${state.errorMessage}'));
          case AuthenticationLoadingState():
            return const Center(child: CircularProgressIndicator());
          case AuthenticationLoadedState():
            return Center(child: ElevatedButton(onPressed: () => { context.read<AuthenticationBloc>().add(SignOutEvent()) }, child: Text('Sign Out')),);
          default:
            return const Center(child: Text('Unknown authentication state'));
        }
      },
    );
  }
}