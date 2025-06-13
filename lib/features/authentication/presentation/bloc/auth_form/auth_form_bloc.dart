import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trepi_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:trepi_app/utils/result.dart';

part 'auth_form_event.dart';
part 'auth_form_state.dart';

class AuthInfo {
  final String email;
  final String password;
  final String? displayName;
  final DateTime dob;

  AuthInfo({
    required this.email,
    required this.password,
    this.displayName,
    required this.dob,
  });
}

class FormBloc extends Bloc<FormEvent, FormsValidate> {
  final AuthenticationRepository _authenticationRepository;
  FormBloc(this._authenticationRepository)
      : super(FormsValidate(
            email: "example@gmail.com",
            password: "",
            isEmailValid: true,
            isPasswordValid: true,
            isFormValid: false,
            isLoading: false,
            isNameValid: true,
            dob: DateTime.now(),
            isAgeValid: true,
            isFormValidateFailed: false)) {
    on<EmailChangedEvent>(_onEmailChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<NameChangedEvent>(_onNameChanged);
    on<DobChangedEvent>(_onDobChanged);
    on<FormSubmittedEvent>(_onFormSubmitted);
    on<FormSucceededEvent>(_onFormSucceeded);
  }

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  bool _isNameValid(String displayName) {
    return displayName.isNotEmpty;
  }

  bool _isDobValid(DateTime dob) {
    DateTime today = DateTime.now();
    DateTime firstDate = DateTime(1900);
    return dob.isAfter(firstDate) && dob.isBefore(today);
  }

  _onEmailChanged(EmailChangedEvent event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValid: false,
      isFormValidateFailed: false,
      errorMessage: "",
      email: event.email,
      isEmailValid: _isEmailValid(event.email),
    ));
    _checkFormValidity(emit);
  }

  _onPasswordChanged(PasswordChangedEvent event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      password: event.password,
      isPasswordValid: event.status == Status.signUp ? _isPasswordValid(event.password) : true,
    ));
    _checkFormValidity(emit);
  }

  _onNameChanged(NameChangedEvent event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      displayName: event.displayName,
      isNameValid: _isNameValid(event.displayName),
    ));
    _checkFormValidity(emit);
  }

  _onDobChanged(DobChangedEvent event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      dob: event.dob,
      isAgeValid: _isDobValid(event.dob),
    ));
    _checkFormValidity(emit);
  }

  _onFormSubmitted(FormSubmittedEvent event, Emitter<FormsValidate> emit) async {
    AuthInfo authInfo = AuthInfo(
      email: state.email,
      password: state.password,
      displayName: state.displayName,
      dob: state.dob,
    );
    if (event.value == Status.signUp) {
      await _trySignUp(event, emit, authInfo);
    } else if (event.value == Status.signIn) {
      await _authenticateUser(event, emit, authInfo);
    }
  }

  _checkFormValidity(Emitter<FormsValidate> emit) {
    emit(state.copyWith(
        isFormValid: _isPasswordValid(state.password) &&
            _isEmailValid(state.email) &&
            _isNameValid(state.displayName ?? '') &&
            _isDobValid(state.dob),
        isLoading: false,
        errorMessage: ""));
  }

  _trySignUp(
      FormSubmittedEvent event, Emitter<FormsValidate> emit, AuthInfo authInfo) async {
    _checkFormValidity(emit);
    if (state.isFormValid) {
      debugPrint("Form is valid, attempting sign up");
      emit(state.copyWith(
          isLoading: true, isFormValidateFailed: false, errorMessage: ""));
      
      final result = await _authenticationRepository.signUp(
          authInfo.email, 
          authInfo.password, 
          authInfo.displayName, 
          authInfo.dob
        );
    
      switch (result) {
        case Ok():
          debugPrint('Signed up successfully');
          emit(state.copyWith(isFormSuccessful: true, isLoading: false));
        case Error():
          emit(state.copyWith(
              isLoading: false, errorMessage: result.error.toString(), isFormValid: false));
          debugPrint("Sign up failed: ${result.error}");

      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _authenticateUser(
      FormSubmittedEvent event, Emitter<FormsValidate> emit, AuthInfo authInfo) async {
    emit(state.copyWith(errorMessage: "",
        isFormValid:
            _isPasswordValid(state.password) && _isEmailValid(state.email),
        isLoading: true));
    if (state.isFormValid) {
      try {
        Result<UserCredential> result = await _authenticationRepository.signInWithEmailAndPassword(authInfo.email, authInfo.password);
        emit(state.copyWith(isLoading: true, isFormValidateFailed: false, errorMessage: ""));
        switch (result) {
          case Ok():
            emit(state.copyWith(isFormSuccessful: true, isLoading: false));
          case Error():
            emit(state.copyWith(
                isLoading: false,
                errorMessage: result.error.toString(),
                isFormValid: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _onFormSucceeded(FormSucceededEvent event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(isFormSuccessful: true));
  }
}