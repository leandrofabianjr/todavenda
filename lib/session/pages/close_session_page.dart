import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/session/bloc/session_bloc.dart';

class CloseSessionPage extends StatelessWidget {
  const CloseSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<SessionBloc>(context)
        ..add(const SessionInitiated()),
      child: const CloseSessionView(),
    );
  }
}

class CloseSessionView extends StatelessWidget {
  const CloseSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    double closingAmount = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fechamento de caixa'),
      ),
      body: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) {
          if (state.status == SessionStatus.closed) {
            return context.go('/caixa/abrir');
          }
          if (state.status == SessionStatus.success) {
            context.read<SessionBloc>().add(const SessionInitiated());
            return context.go('/caixa');
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case SessionStatus.exception:
              return ExceptionWidget(exception: state.exception);

            case SessionStatus.open:
              return ListView(
                children: [
                  ListTile(
                    tileColor: colorScheme.errorContainer,
                    textColor: colorScheme.onErrorContainer,
                    iconColor: colorScheme.onErrorContainer,
                    leading: const Icon(Icons.info_outline),
                    subtitle: const Text(
                        'Ao fechar o caixa você pode informar o valor contabilizado manualmente para posterior verificação. Não é obrigatório informá-lo.\nPara finalizar, clique no botão de confirmação.'),
                  ),
                  ListTile(
                    title: CurrencyField(
                      decoration: InputDecoration(
                        label: const Text('Valor contabilizado no fechamento'),
                        errorText: state.errorMessage,
                      ),
                      initialValue: closingAmount,
                      onChanged: (value) => closingAmount = value,
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
          if (state.status != SessionStatus.closed) {
            return FloatingActionButton.extended(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              onPressed: () => context
                  .read<SessionBloc>()
                  .add(SessionClosed(closingAmount: closingAmount)),
              icon: const Icon(Icons.close),
              label: const Text('Confirmar fechamento de caixa'),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
