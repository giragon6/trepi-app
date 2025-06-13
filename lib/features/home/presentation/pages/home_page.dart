import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/route_names.dart';
import 'package:trepi_app/features/authentication/domain/entities/user_entity.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  final String title = 'Trepi App';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        switch (authState) {
          case AuthenticationSignedOutState(): 
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushReplacement(RouteNames.signIn);
            });
            return Scaffold(
              body: Center(
                child: Text('You are signed out. Redirecting to sign-in page...'),
              ),
            );

          case AuthenticationErrorState(): 
            return Scaffold(
              body: Center(
                child: Text('Authentication error: ${authState.errorMessage}'),
              ),
            );
          
          case AuthenticationLoadingState():
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );

          case AuthenticationLoadedState(): 
            return _buildHomeContent(context, authState.user);

          default: 
            return const Scaffold(
              body: Center(child: Text('Unknown authentication state')),
            );
          }
        } 
    );
  }

  Widget _buildHomeContent(BuildContext context, UserEntity user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome, ${user.displayName}!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Email verification status
          if (!user.isEmailVerified) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 48),
                  const SizedBox(height: 8),
                  const Text(
                    'Please verify your email',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Check your inbox for a verification link.'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthenticationBloc>().add(ResendVerificationEvent());
                        },
                        child: const Text('Resend Email'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthenticationBloc>().add(RefreshUserEvent());
                        },
                        child: const Text('I\'ve Verified'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: Colors.green, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Email verified ✓',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}