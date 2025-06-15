import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/features/authentication/domain/usecases/verify_email.dart';
import 'package:trepi_app/utils/result.dart';

part 'email_verification_event.dart';
part 'email_verification_state.dart';

class EmailVerificationBloc extends Bloc<EmailVerificationEvent, EmailVerificationState>{
  final VerifyEmail _verifyEmail;

  EmailVerificationBloc({required VerifyEmail verifyEmail}) : 
    _verifyEmail = verifyEmail,
    super(EmailVerificationInitialState()) {
      on<EmailVerificationRequestedEvent>(_onEmailVerificationRequested);
      on<EmailVerificationCheckEvent>(_onEmailVerificationCheck);
    }

  void _onEmailVerificationRequested(EmailVerificationRequestedEvent event, Emitter<EmailVerificationState> emit) async {
    final result = await _verifyEmail.sendVerifyEmail();
    emit(EmailVerificationLoadingState());
    switch (result) {
      case Ok<void>():
        emit(EmailSentState());
        break;
      case Error():
        emit(EmailVerificationErrorState(result.error.toString()));
        break;
    }
  }

  void _onEmailVerificationCheck(EmailVerificationCheckEvent event, Emitter<EmailVerificationState> emit) async {
    bool emailSent = false;

    if (state is EmailVerificationLoadingState) return; 
    if (state is EmailSentState) emailSent = true;

    emit(EmailVerificationLoadingState());
    
    final result = await _verifyEmail.checkEmailVerificationStatus();
    
    switch (result) {
      case Ok<bool>():
        if (result.value == true) {
          emit(EmailVerifiedState());
        } else {
          emailSent ? emit(EmailSentState()) : emit(EmailNotVerifiedState());
        }
        break;
      case Error():
        emit(EmailVerificationErrorState(result.error.toString()));
        break;
    }
  }
}