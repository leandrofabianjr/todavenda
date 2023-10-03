import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:todavenda/auth/bloc/auth_bloc.dart';
import 'package:todavenda/commons/commons.dart';

class CompanyPage extends StatelessWidget {
  const CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: user.picture != null
                      ? Image.network(user.picture!)
                      : Icon(
                          Icons.account_circle,
                          size: 60,
                          color: colorScheme.onPrimary,
                        ),
                  currentAccountPictureSize: const Size(60, 60),
                  accountName: Text(user.name),
                  accountEmail: Text(user.email),
                  otherAccountsPictures: [
                    const VersionText(),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close),
                      color: colorScheme.onPrimary,
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sair'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => const LogoutConfirmationDialog(),
                    );
                  },
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

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deseja realmente sair da aplicação?'),
      actions: [
        TextButton(
          onPressed: () => context.read<AuthBloc>().add(const AuthLoggedOut()),
          child: const Text('Sim, quero sair'),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancelar'),
        )
      ],
    );
  }
}

class VersionText extends StatefulWidget {
  const VersionText({super.key});

  @override
  State<VersionText> createState() => _VersionTextState();
}

class _VersionTextState extends State<VersionText> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final info = snapshot.data!;
          return Text(
            'v${info.version}',
            softWrap: false,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 12,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
