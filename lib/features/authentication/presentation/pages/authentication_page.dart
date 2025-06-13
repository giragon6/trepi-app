import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _AuthenticationPageContent();
  }
}

class _AuthenticationPageContent extends StatelessWidget {
  const _AuthenticationPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationErrorState) {
          debugPrint('Authentication error: ${state.errorMessage}');
          context.pushReplacement('/sign-in');
        } else if (state is AuthenticationLoadedState) {
          debugPrint('Authentication loaded: ${state.user.displayName}');
        }
      },
      buildWhen: (previous, current) => current is! AuthenticationErrorState,
      builder: (context, authState) {
        if (authState is! AuthenticationLoadedState) {
          debugPrint('Authentication not loaded yet');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(authState.user.displayName),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () => context.read<AuthenticationBloc>().add(SignOutEvent()),
              )
            ],
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.blue,
            ),
          ),
          body: Center(
            child: Text(
              'Welcome, ${authState.user.displayName}!',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}