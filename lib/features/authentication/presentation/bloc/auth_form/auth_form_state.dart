part of 'auth_form_bloc.dart';
 
abstract class FormState extends Equatable {
  const FormState();
}
 
class FormInitial extends FormState {
  @override
  List<Object?> get props => [];
}
 
class FormsValidate extends FormState {
  const FormsValidate(
      {required this.email,
      required this.password,
      required this.isEmailValid,
      required this.isPasswordValid,
      required this.isFormValid,
      required this.isLoading,
      this.errorMessage = "",
      required this.isNameValid,
      required this.isAgeValid,
      required this.isFormValidateFailed,
      this.displayName,
      required this.dob,
      this.isFormSuccessful = false});
 
  final String email;
  final String? displayName;
  final DateTime dob;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isFormValid;
  final bool isNameValid;
  final bool isAgeValid;
  final bool isFormValidateFailed;
  final bool isLoading;
  final String errorMessage;
  final bool isFormSuccessful;
 
  FormsValidate copyWith(
      {String? email,
      String? password,
      String? displayName,
      bool? isEmailValid,
      bool? isPasswordValid,
      bool? isFormValid,
      bool? isLoading,
      DateTime? dob,
      String? errorMessage,
      bool? isNameValid,
      bool? isAgeValid,
      bool? isFormValidateFailed,
      bool? isFormSuccessful}) {
    return FormsValidate(
        email: email ?? this.email,
        password: password ?? this.password,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isFormValid: isFormValid ?? this.isFormValid,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        isNameValid: isNameValid ?? this.isNameValid,
        dob: dob ?? this.dob,
        isAgeValid: isAgeValid ?? this.isAgeValid,
        displayName: displayName ?? this.displayName,
        isFormValidateFailed: isFormValidateFailed ?? this.isFormValidateFailed,
        isFormSuccessful: isFormSuccessful ?? this.isFormSuccessful);
  }
 
  @override
  List<Object?> get props => [
        email,
        password,
        isEmailValid,
        isPasswordValid,
        isFormValid,
        isLoading,
        errorMessage,
        isNameValid,
        displayName,
        dob,
        isFormValidateFailed,
        isFormSuccessful
      ];
}