import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trepi_app/features/authentication/domain/entities/user_entity.dart';
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
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<NameChanged>(_onNameChanged);
    on<DobChanged>(_onDobChanged);
    on<FormSubmitted>(_onFormSubmitted);
    on<FormSucceeded>(_onFormSucceeded);
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

  bool _isNameValid(String? displayName) {
    return displayName!.isNotEmpty;
  }

  bool _isDobValid(DateTime dob) {
    DateTime today = DateTime.now();
    DateTime firstDate = DateTime(1900);
    int age = today.year - dob.year;
    if (dob.month > today.month || (dob.month == today.month && dob.day > today.day)) {
      age--;
    }
    return dob.isAfter(firstDate) && dob.isBefore(today);
  }

  _onEmailChanged(EmailChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValid: false,
      isFormValidateFailed: false,
      errorMessage: "",
      email: event.email,
      isEmailValid: _isEmailValid(event.email),
    ));
  }

  _onPasswordChanged(PasswordChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      password: event.password,
      isPasswordValid: _isPasswordValid(event.password),
    ));
  }

  _onNameChanged(NameChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      displayName: event.displayName,
      isNameValid: _isNameValid(event.displayName),
    ));
  }

  _onDobChanged(DobChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      dob: event.dob,
      isAgeValid: _isDobValid(event.dob),
    ));
  }

  _onFormSubmitted(FormSubmitted event, Emitter<FormsValidate> emit) async {
    AuthInfo authInfo = AuthInfo(
      email: state.email,
      password: state.password,
      displayName: state.displayName,
      dob: state.dob,
    );

    if (event.value == Status.signUp) {
      await _updateUIAndSignUp(event, emit, authInfo);
    } else if (event.value == Status.signIn) {
      await _authenticateUser(event, emit, authInfo);
    }
  }

  _updateUIAndSignUp(
      FormSubmitted event, Emitter<FormsValidate> emit, AuthInfo authInfo) async {
    emit(
      state.copyWith(errorMessage: "",
        isFormValid: _isPasswordValid(state.password) &&
            _isEmailValid(state.email) &&
            _isDobValid(state.dob) &&
            _isNameValid(state.displayName),
        isLoading: true));
    if (state.isFormValid) {
      try {
        await _authenticationRepository.signUp(authInfo.email, authInfo.password);
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _authenticateUser(
      FormSubmitted event, Emitter<FormsValidate> emit, AuthInfo authInfo) async {
    emit(state.copyWith(errorMessage: "",
        isFormValid:
            _isPasswordValid(state.password) && _isEmailValid(state.email),
        isLoading: true));
    if (state.isFormValid) {
      try {
        Result<UserCredential> result = await _authenticationRepository.signInWithEmailAndPassword(authInfo.email, authInfo.password);
        switch (result) {
          case Ok():
            UserCredential authUser = result.value;
            UserEntity updatedUser = UserEntity(
              providerId: authUser.user?.providerData.isNotEmpty == true
                  ? authUser.user!.providerData[0].providerId
                  : '',
              uid: authUser.user?.uid ?? '',
              email: authInfo.email,
              displayName: authInfo.displayName ?? 'Anonymous',
            );
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

  _onFormSucceeded(FormSucceeded event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(isFormSuccessful: true));
  }
}