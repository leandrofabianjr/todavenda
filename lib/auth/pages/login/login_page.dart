import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/auth/bloc/auth_bloc.dart';
import 'package:todavenda/auth/pages/login/bloc/login_bloc.dart';
import 'package:todavenda/auth/services/auth_service.dart';
import 'package:todavenda/commons/commons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authService: context.read<AuthService>()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Toda Venda',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 80),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  context.read<AuthBloc>().add(AuthLogged(user: state.user));
                  context.pushReplacement('/');
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const LoadingWidget();
                }
                return Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<LoginBloc>()
                          .add(const LoginWithGoogleRequested()),
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text('Login com conta Google'),
                    ),
                    if (state is LoginException)
                      const Text('Não foi possível fazer o login'),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
