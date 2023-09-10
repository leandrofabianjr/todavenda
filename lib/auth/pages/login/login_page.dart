import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/auth/bloc/auth_bloc.dart';
import 'package:todavenda/auth/pages/login/bloc/login_bloc.dart';
import 'package:todavenda/auth/services/services.dart';
import 'package:todavenda/commons/commons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authService: context.read<AuthService>(),
        usersRepository: context.read<UsersRepository>(),
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/');
          }
        },
        child: const LoginView(),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Toda Venda',
                textAlign: TextAlign.center,
                style: textTheme.displaySmall
                    ?.copyWith(color: colorScheme.onPrimary),
              ),
              const SizedBox(height: 32.0),
              Card(
                color: colorScheme.onPrimary,
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state.status == LoginStatus.success) {
                        context
                            .read<AuthBloc>()
                            .add(AuthLogged(user: state.user!));
                      }
                    },
                    builder: (context, state) {
                      if (state.status == LoginStatus.loading) {
                        return const LoadingWidget();
                      }

                      var email = state.email;
                      var password = state.password;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: TextEditingController(text: email),
                            decoration: const InputDecoration(
                              label: Text('E-mail'),
                            ),
                            onChanged: (value) => email = value,
                          ),
                          TextField(
                            controller: TextEditingController(text: password),
                            decoration: const InputDecoration(
                              label: Text('Senha'),
                            ),
                            onChanged: (value) => password = value,
                          ),
                          const SizedBox(height: 16.0),
                          if (state.status == LoginStatus.failure)
                            Text(
                              state.errorMessage!,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.error,
                              ),
                            ),
                          const SizedBox(height: 8.0),
                          TextButton(
                            onPressed: () => context.read<LoginBloc>().add(
                                  LoginWithEmail(
                                    email: email,
                                    password: password,
                                  ),
                                ),
                            child: const Text('Entrar'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
