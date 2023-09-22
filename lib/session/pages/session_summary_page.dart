import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/session/bloc/session_bloc.dart';

class SessionSummaryPage extends StatelessWidget {
  const SessionSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<SessionBloc>(context)
        ..add(const SessionInitiated()),
      child: const SessionSummaryView(),
    );
  }
}

class SessionSummaryView extends StatelessWidget {
  const SessionSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/vender'),
          ),
          title: const Text('Caixa atual')),
      body: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) {
          if (state.status == SessionStatus.closed) {
            context.go('/caixa/abrir');
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case SessionStatus.closed:
            case SessionStatus.loading:
              return const LoadingWidget();
            default:
              final session = state.session;
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        DescriptionDetail(
                          description: const Text('Sessão aberta em'),
                          detail: Text(
                            session.formattedCreatedAt,
                          ),
                        ),
                        DescriptionDetail(
                          description: const Text('Dinheiro em caixa'),
                          detail: Text(
                            session.formattedCurrentAmount,
                            style: textTheme.titleLarge,
                          ),
                        ),
                        DescriptionDetail(
                          description: const Text('Suprimentos'),
                          detail: Text(
                            session.formattedSupplyAmount,
                            style: textTheme.titleLarge,
                          ),
                        ),
                        DescriptionDetail(
                          description: const Text('Sangrias'),
                          detail: Text(
                            session.formattedPickUpAmount,
                            style: textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Divider(),
                      const Text('Operações'),
                      ListTile(
                        onTap: () => context.go('/caixa/suprir'),
                        leading: const Icon(Icons.login),
                        title: const Text('Suprimento'),
                      ),
                      ListTile(
                        onTap: () => context.go('/caixa/sangrar'),
                        leading: const Icon(Icons.logout),
                        title: const Text('Sangria'),
                      ),
                      ListTile(
                        onTap: () => context.go('/caixa/fechar'),
                        leading: const Icon(Icons.archive_outlined),
                        title: const Text('Fechamento'),
                        textColor: colorScheme.error,
                        iconColor: colorScheme.error,
                      ),
                    ],
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
