part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  List<Object> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {
  final bool isLoading;

  const AuthenticationLoadingState({required this.isLoading});
}

class AuthenticationLoadedState extends AuthenticationState {
  final UserEntity user;

  const AuthenticationLoadedState(this.user);
  @override
  List<Object> get props => [user];
}

class AuthenticationSignedOutState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationErrorState extends AuthenticationState {
  final String errorMessage;

  const AuthenticationErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}