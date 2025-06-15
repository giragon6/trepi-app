import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/route_names.dart';
import 'package:trepi_app/features/authentication/domain/entities/user_entity.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/email_verification/email_verification_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String title = 'Home Page';

  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(RefreshUserEvent());
    context.read<EmailVerificationBloc>().add(EmailVerificationCheckEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        switch (authState) {
          case AuthenticationSignedOutState(): 
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.pushReplacement(RouteNames.signIn);
              }
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

  Widget _buildEmailNotVerifiedContent(BuildContext context, UserEntity user, bool emailSent) {
    return 
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
          Text(emailSent ? 'Check your inbox for a verification link.' : 'Click the button below to send a verification email.'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              () {
                if (!emailSent) {
                return ElevatedButton(
                onPressed: () {
                  context.read<EmailVerificationBloc>().add(EmailVerificationRequestedEvent());
                },
                child: Text(emailSent ? 'Resend Email' : 'Send Verification Email'),);
              } else {
                return SizedBox.shrink();
              }
              }(),
              ElevatedButton(
                onPressed: () {
                  context.read<EmailVerificationBloc>().add(EmailVerificationCheckEvent());
                },
                child: const Text('I\'ve Verified'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmailVerifiedContent() =>    
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
    );

  Widget _buildHomeContent(BuildContext context, UserEntity user) {
    return Scaffold(
        body: Column(
        children: [
          Text(
            user.displayName.isNotEmpty ? 'Welcome, ${user.displayName}!' : 'Welcome!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          BlocBuilder<EmailVerificationBloc, EmailVerificationState>(
            builder: (context, verifState) {
              debugPrint('EmailVerificationBloc state: $verifState');
              switch (verifState) {
                case EmailVerificationLoadingState():
                  return const CircularProgressIndicator();              

                case EmailSentState():
                  return _buildEmailNotVerifiedContent(context, user, true);
                
                case EmailNotVerifiedState():
                  return _buildEmailNotVerifiedContent(context, user, false);

                case EmailVerifiedState():
                  return _buildEmailVerifiedContent();

                case EmailVerificationErrorState():
                  return Center(
                    child: Text('Error verifying email: ${verifState.error}'),
                  );

                default:
                  return const SizedBox.shrink();
              }
            }
          ),]          
    ));
  }
}