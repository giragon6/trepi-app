import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trepi_app/core/routing/route_names.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth_form/auth_form_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    debugPrint('SignUpPage build called');
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
        listeners: [
          BlocListener<FormBloc, FormsValidate>(
            listener: (context, state) {
              if (state.errorMessage.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(errorMessage: state.errorMessage),
                );
              } else if (state.isFormValid && !state.isLoading) {
                context.read<FormBloc>().add(const FormSucceeded());
              } else if (state.isFormValidateFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationLoadedState) {
                context.pushReplacement(RouteNames.home);
              }
            },
          ),
        ],
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Create an Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          )),
                      Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.02)),
                      const _EmailField(),
                      SizedBox(height: size.height * 0.01),
                      const _PasswordField(),
                      SizedBox(height: size.height * 0.01),
                      const _DisplayNameField(),
                      SizedBox(height: size.height * 0.01),
                      const _DobField(),
                      SizedBox(height: size.height * 0.01),
                      const _SubmitButton()
                    ]),
              ),
            )
          )
        );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
              onChanged: (value) {
                context.read<FormBloc>().add(EmailChanged(value));
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                helperText: 'e.g., example@gmail.com',
                errorText: !state.isEmailValid
                    ? 'Please enter a valid email address'
                    : null,
                hintText: 'Email',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
              )),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              labelText: 'Password',
              errorMaxLines: 2,
              errorText: !state.isPasswordValid
                  ? 'Password must be at least 8 characters and contain at least one letter and number'
                  : null,
            ),
            onChanged: (value) {
              context.read<FormBloc>().add(PasswordChanged(value));
            },
          ),
        );
      },
    );
  }
}

class _DisplayNameField extends StatelessWidget {
  const _DisplayNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              labelText: 'Name',
              errorMaxLines: 2,
              errorText:
                  !state.isNameValid ? 'Name cannot be empty' : null,
            ),
            onChanged: (value) {
              context.read<FormBloc>().add(NameChanged(value));
            },
          ),
        );
      },
    );
  }
}

class _DobField extends StatelessWidget {
  const _DobField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            readOnly: true, // Prevent manual typing
            controller: TextEditingController(
              text: '${state.dob.day}/${state.dob.month}/${state.dob.year}'
            ),
            decoration: InputDecoration(
              labelText: 'Date of Birth',
              hintText: 'Select your date of birth',
              suffixIcon: const Icon(Icons.calendar_today),
              errorText: !state.isAgeValid 
                ? 'Please select a valid date of birth' 
                : null,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0, 
                horizontal: 10.0
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 6570)), // ~18 years ago
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              
              if (pickedDate != null) {
                context.read<FormBloc>().add(DobChanged(pickedDate));
              }
            },
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: size.width * 0.8,
                child: OutlinedButton(
                  onPressed: !state.isFormValid
                      ? () => context
                          .read<FormBloc>()
                          .add(const FormSubmitted(value: Status.signUp))
                      : null,
                  style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all<Color>(
                          Colors.white),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.blue),
                      side:
                          WidgetStateProperty.all<BorderSide>(BorderSide.none)),
                  child: const Text('Sign Up'),
                ),
              );
      },
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String? errorMessage;
  const ErrorDialog({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(errorMessage!),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () => context.pop(),
        )
      ],
    );
  }
}