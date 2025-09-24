import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdm/features/auth/presentation/bloc/auth_bloc.dart';

/// A simple widget that provides a button to manually refresh tokens
/// This is useful for testing or debugging purposes
class TokenRefreshButton extends StatelessWidget {
  final String? text;

  const TokenRefreshButton({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthTokenRefreshed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token refreshed successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Token refresh failed: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: ElevatedButton(
        onPressed: () {
          context.read<AuthBloc>().add(RefreshTokenRequested());
        },
        child: Text(text ?? 'Refresh Token'),
      ),
    );
  }
}


