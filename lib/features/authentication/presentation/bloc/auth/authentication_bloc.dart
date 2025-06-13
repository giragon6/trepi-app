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
              emit(AuthenticationLoadedState(user));
            } else {
              emit(AuthenticationErrorState('User not found'));
            }
          case Error():
            if (result.error.toString().contains('No user signed in')) {
              emit(AuthenticationSignedOutState());
            } else {
              emit(AuthenticationErrorState(result.error.toString()));
            }
        }
      },
      onError: (error) {
        emit(AuthenticationErrorState(error.toString()));
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