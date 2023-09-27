import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/session/services/sessions_repository.dart';

import 'bloc/session_bloc.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionBloc(
        context.read<SessionsRepository>(),
        uuid: uuid,
      )..add(const SessionStarted()),
      child: const SessionView(),
    );
  }
}

class SessionView extends StatelessWidget {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sessão')),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          if (state is SessionLoading) {
            return const LoadingWidget();
          }

          if (state is SessionLoaded) {
            final session = state.session;

            return ListView(
              children: [
                SectionCardWidget(
                  children: [
                    DescriptionDetail(
                      description: const Text('Sessão aberta em'),
                      detail: Text(
                        session.formattedCreatedAt,
                      ),
                    ),
                    DescriptionDetail(
                      description: const Text('Valor de abertura'),
                      detail: Text(
                        session.formattedOpeningAmount,
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
                    DescriptionDetail(
                      description: const Text('Total no fechamento'),
                      detail: Text(
                        session.formattedCurrentAmount,
                        style: textTheme.titleLarge,
                      ),
                    ),
                    DescriptionDetail(
                      description: const Text('Total informado no fechamento'),
                      detail: Text(
                        session.formattedClosingAmount,
                        style: textTheme.titleLarge,
                      ),
                    ),
                    DescriptionDetail(
                      description: const Text('Diferença no fechamento'),
                      detail: Text(
                        session.formattedClosingDifference,
                        style: textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return ExceptionWidget(
            exception: state is SessionException ? state.ex : null,
          );
        },
      ),
    );
  }
}
