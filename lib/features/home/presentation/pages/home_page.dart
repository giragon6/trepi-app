import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/route_names.dart';
import 'package:trepi_app/features/authentication/domain/entities/user_entity.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/email_verification/email_verification_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/widgets/email_verification/email_not_verified_widget.dart';
import 'package:trepi_app/features/authentication/presentation/widgets/email_verification/email_sent_widget.dart';
import 'package:trepi_app/features/authentication/presentation/widgets/email_verification/email_verified_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String title = 'Home Page';
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, authState) {
        if (authState is AuthenticationSignedOutState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.pushReplacement(RouteNames.signIn);
            }
          });
        }
      },
      builder: (context, authState) {
        switch (authState) {
          case AuthenticationSignedOutState(): 
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
                  return EmailSentWidget(
                    onRefreshButtonPressed: () {
                      context.read<EmailVerificationBloc>().add(EmailVerificationCheckEvent());
                    }
                  );
                
                case EmailNotVerifiedState():
                  return EmailNotVerifiedWidget(
                    onRequestButtonPressed: () {
                      context.read<EmailVerificationBloc>().add(EmailVerificationRequestedEvent());
                    },
                    onRefreshButtonPressed: () {
                      context.read<EmailVerificationBloc>().add(EmailVerificationCheckEvent());
                    },
                  );

                case EmailVerifiedState():
                  return EmailVerifiedWidget();

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