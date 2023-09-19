import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/pages/sessions_list/bloc/sessions_list_bloc.dart';
import 'package:todavenda/session/services/sessions_repository.dart';

class SessionsListPage extends StatelessWidget {
  const SessionsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionsListBloc(context.read<SessionsRepository>())
        ..add(const SessionsListRefreshed()),
      child: const SessionsListView(),
    );
  }
}

class SessionsListView extends StatelessWidget {
  const SessionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sessões')),
      body: BlocBuilder<SessionsListBloc, SessionsListState>(
        builder: (context, state) {
          if (state is SessionsListLoading) {
            return const LoadingWidget();
          }

          if (state is SessionsListLoaded) {
            final sessions = state.sessions;
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<SessionsListBloc>()
                  .add(const SessionsListRefreshed()),
              child: sessions.isEmpty
                  ? const Center(child: Text('Nenhuma sessão foi aberta'))
                  : ListView(
                      children: sessions
                          .expand((sale) => [
                                SessionListTile(session: sale),
                                const Divider(),
                              ])
                          .toList()),
            );
          }

          return ExceptionWidget(
            exception: state is SessionsListException ? state.ex : null,
          );
        },
      ),
    );
  }
}

class SessionListTile extends StatelessWidget {
  const SessionListTile({
    super.key,
    required this.session,
  });

  final Session session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      trailing: Text(
        session.formattedCurrentAmount,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
      title: Text(session.formattedCreatedAt),
      onTap: () => context.go('/relatorios/sessoes/${session.uuid}'),
    );
  }
}
