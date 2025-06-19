import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/features/authentication/domain/entities/user_entity.dart';
import 'package:trepi_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:trepi_app/utils/result.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<Result<UserEntity>> _authSubscription;

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitialState()) {
    
    _startListeningToAuthChanges();
    
    on<SignOutEvent>(_onSignOut);
    on<LoadAuthenticationEvent>(_onLoadAuthentication);
    on<LoadedAuthenticationEvent>(_onLoadedAuthentication);
    on<AuthenticationErrorEvent>(_onAuthenticationError);
    on<RefreshUserEvent>(_onRefreshUser);
    on<ResendVerificationEvent>(_onResendVerification);
  }

  void _startListeningToAuthChanges() {
    _authSubscription = _authenticationRepository.getCurrentUser().listen(
      (result) {
        switch (result) {
          case Ok():
            final user = result.value;
            if (user.uid.isNotEmpty) {
              add(LoadedAuthenticationEvent(user));
            } else {
              add(AuthenticationErrorEvent('User not found'));
            }
          case Error():
            if (result.error.toString().contains('No user signed in')) {
              add(SignOutEvent());
            } else {
              add(AuthenticationErrorEvent(result.error.toString()));
            }
        }
      },
    );
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthenticationState> emit) async {
    try {
      await _authenticationRepository.signOut();
      emit(AuthenticationSignedOutState());
    } catch (e) {
      emit(AuthenticationErrorState('Sign out failed: $e'));
    }
  }

  Future<void> _onLoadAuthentication(LoadAuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoadingState(isLoading: true));
  }

  Future<void> _onLoadedAuthentication(LoadedAuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoadedState(event.user));
  }

  Future<void> _onAuthenticationError(AuthenticationErrorEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationErrorState(event.errorMessage));
  }

  Future<void> _onRefreshUser(RefreshUserEvent event, Emitter<AuthenticationState> emit) async {
    try {
      await _authenticationRepository.refreshCurrentUser();
    } catch (e) {
      emit(AuthenticationErrorState('Failed to refresh user: $e'));
    }
  }

  Future<void> _onResendVerification(ResendVerificationEvent event, Emitter<AuthenticationState> emit) async {
    try {
      await _authenticationRepository.verifyEmail();
    } catch (e) {
      emit(AuthenticationErrorState('Failed to resend verification email: $e'));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel(); 
    return super.close();
  }
}