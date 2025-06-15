part of 'email_verification_bloc.dart';

abstract class EmailVerificationEvent extends Equatable {
  const EmailVerificationEvent();

  @override
  List<Object> get props => [];
}

class EmailVerificationRequestedEvent extends EmailVerificationEvent {}

class EmailVerificationCheckEvent extends EmailVerificationEvent {}