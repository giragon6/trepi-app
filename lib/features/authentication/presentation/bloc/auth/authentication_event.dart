part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];

}

class LoadAuthenticationEvent extends AuthenticationEvent {
  const LoadAuthenticationEvent();

  @override
  List<Object> get props => [];
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