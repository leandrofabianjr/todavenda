import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/session/bloc/session_bloc.dart';
import 'package:todavenda/session/services/sessions_repository.dart';

class CreateSessionPage extends StatelessWidget {
  const CreateSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionBloc(context.read<SessionsRepository>())
        ..add(const SessionInitiated()),
      child: const CreateSessionView(),
    );
  }
}

class CreateSessionView extends StatelessWidget {
  const CreateSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    double openingAmount = 0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Abertura de caixa'),
      ),
      body: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) {
          if (state.status == SessionStatus.open) {
            return context.go('/vender');
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case SessionStatus.exception:
              return ExceptionWidget(exception: state.exception);

            case SessionStatus.closed:
              return ListView(
                children: [
                  ListTile(
                    tileColor: colorScheme.primaryContainer,
                    textColor: colorScheme.onPrimaryContainer,
                    iconColor: colorScheme.onPrimaryContainer,
                    leading: const Icon(Icons.info_outline),
                    subtitle: const Text(
                        'Na abertura de um novo caixa, você pode informar um valor de abertura de caixa que servirá como fundo de troco.\nSe não houver valor de abertura, apenas clique no botão para abrir o caixa.'),
                  ),
                  ListTile(
                    title: CurrencyField(
                      decoration: const InputDecoration(
                        label: Text('Valor de abertura de caixa'),
                      ),
                      initialValue: openingAmount,
                      onChanged: (value) => openingAmount = value,
                    ),
                  ),
                ],
              );

            default:
              return const LoadingWidget();
          }
        },
      ),
      floatingActionButton: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          if (state.status == SessionStatus.closed) {
            return FloatingActionButton.extended(
              onPressed: () => context
                  .read<SessionBloc>()
                  .add(SessionCreated(openingAmount: openingAmount)),
              icon: const Icon(Icons.check),
              label: const Text('Abrir novo caixa'),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
