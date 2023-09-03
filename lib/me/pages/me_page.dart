import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/auth/bloc/auth_bloc.dart';
import 'package:todavenda/commons/commons.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is! AuthSuccess) {
            context.pushReplacement('/login');
          }
        },
        builder: (context, state) {
          if (state is AuthSuccess) {
            final user = state.user;
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      UserAccountsDrawerHeader(
                        currentAccountPicture: user.picture != null
                            ? Image.network(user.picture!)
                            : Icon(
                                Icons.account_circle,
                                size: 60,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        currentAccountPictureSize: const Size(60, 60),
                        accountName: Text(user.name),
                        accountEmail: Text(user.email),
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sair'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title:
                              const Text('Deseja realmente sair da aplicação?'),
                          actions: [
                            TextButton(
                              onPressed: () => context
                                  .read<AuthBloc>()
                                  .add(const AuthLoggedOut()),
                              child: const Text('Sim, quero sair'),
                            ),
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text('Cancelar'),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
