part of 'auth_form_bloc.dart';
 
enum Status { signIn, signUp }
 
abstract class FormEvent extends Equatable {
  const FormEvent();
 
  @override
  List<Object> get props => [];
}
 
class EmailChangedEvent extends FormEvent {
  final String email;
  const EmailChangedEvent(this.email);
 
  @override
  List<Object> get props => [email];
}
 
class PasswordChangedEvent extends FormEvent {
  final String password;
  final Status status;

  const PasswordChangedEvent(this.password, {required this.status});
 
  @override
  List<Object> get props => [password];
}
 
class NameChangedEvent extends FormEvent {
  final String displayName;
  const NameChangedEvent(this.displayName);
 
  @override
  List<Object> get props => [displayName];
}
 
class DobChangedEvent extends FormEvent {
  final DateTime dob;
  const DobChangedEvent(this.dob);
 
  @override
  List<Object> get props => [dob];
}
 
class FormSubmittedEvent extends FormEvent {
  final Status value;
  const FormSubmittedEvent({required this.value});
 
  @override
  List<Object> get props => [value];
}
 
class FormSucceededEvent extends FormEvent {
  const FormSucceededEvent();
 
  @override
  List<Object> get props => [];
}