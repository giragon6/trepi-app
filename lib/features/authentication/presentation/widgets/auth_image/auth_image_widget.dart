import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trepi_app/features/authentication/presentation/bloc/auth/authentication_bloc.dart';

class AuthImageWidget extends StatelessWidget {
  void Function() _onPressed;
  
  AuthImageWidget({
    super.key,
    required void Function() onPressed,
  }) : _onPressed = onPressed;  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        const radius = 20.0;
        return TextButton(
          onPressed: _onPressed,
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            minimumSize: Size(radius * 2, radius * 2),
          ),
          child: _avatar(authState, radius: radius),
        );
      },
    );
  }

  CircleAvatar _avatar(AuthenticationState authState, {double radius = 30.0}) {
    CircleAvatar defaultAvatar = CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage('assets/images/default_avatar_padded.png'),
    );

    if (authState is AuthenticationLoadedState) {
      return authState.user.photoUrl != null && authState.user.photoUrl!.isNotEmpty
        ? CircleAvatar(
            foregroundImage: NetworkImage(authState.user.photoUrl!),
            radius: radius,
          )
        : defaultAvatar;
      } else {
        return defaultAvatar;
    }
  }
}