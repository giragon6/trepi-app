part of 'email_verification_bloc.dart';

abstract class EmailVerificationState extends Equatable {
  const EmailVerificationState();

  @override
  List<Object> get props => [];
}

class EmailVerificationInitialState extends EmailVerificationState {}

class EmailSentState extends EmailVerificationState {}

class EmailVerificationLoadingState extends EmailVerificationState {}

class EmailNotVerifiedState extends EmailVerificationState {
  final String? message;

  EmailNotVerifiedState({this.message});
  
  @override
  List<Object> get props => [message ?? ''];
}

class EmailVerifiedState extends EmailVerificationState {}

class EmailVerificationErrorState extends EmailVerificationState {
  final String error;

  const EmailVerificationErrorState(this.error);

  @override
  List<Object> get props => [error];
}