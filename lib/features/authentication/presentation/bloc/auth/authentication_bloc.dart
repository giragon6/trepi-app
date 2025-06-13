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
            emit(AuthenticationErrorState(result.error.toString()));
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
    } catch (e) {
      emit(AuthenticationErrorState('Sign out failed: $e'));
    }
  }

  Future<void> _onLoadAuthentication(LoadAuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoadingState(isLoading: true));
  }

  @override
  Future<void> close() {
    _authSubscription.cancel(); 
    return super.close();
  }
}