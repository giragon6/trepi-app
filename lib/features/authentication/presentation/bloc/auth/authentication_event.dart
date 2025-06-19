part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];

}

class LoadAuthenticationEvent extends AuthenticationEvent {
  const LoadAuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoadedAuthenticationEvent extends AuthenticationEvent {
  final UserEntity user;

  const LoadedAuthenticationEvent(this.user);

  @override
  List<Object> get props => [user];
}

class AuthenticationErrorEvent extends AuthenticationEvent {
  final String errorMessage;

  const AuthenticationErrorEvent(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class RefreshUserEvent extends AuthenticationEvent {
  const RefreshUserEvent();

  @override
  List<Object> get props => [];
}

class ResendVerificationEvent extends AuthenticationEvent {
  const ResendVerificationEvent();

  @override
  List<Object> get props => [];
}

class SignOutEvent extends AuthenticationEvent {}