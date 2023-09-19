import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/session/bloc/session_bloc.dart';

class CreateSessionSupplyPage extends StatelessWidget {
  const CreateSessionSupplyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<SessionBloc>(context)
        ..add(const SessionInitiated()),
      child: const CreateSessionSupplyView(),
    );
  }
}

class CreateSessionSupplyView extends StatelessWidget {
  const CreateSessionSupplyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    double amount = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suprimento de caixa'),
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
                    tileColor: colorScheme.primaryContainer,
                    textColor: colorScheme.onPrimaryContainer,
                    iconColor: colorScheme.onPrimaryContainer,
                    leading: const Icon(Icons.info_outline),
                    subtitle: const Text(
                        'Informe o valor em dinheiro a ser adicionado ao fundo de troco no caixa da sessão atual e clice no botão de confirmação.'),
                  ),
                  ListTile(
                    title: CurrencyField(
                      decoration: InputDecoration(
                        label: const Text('Valor a ser adicionado ao caixa'),
                        errorText: state.errorMessage,
                      ),
                      initialValue: amount,
                      onChanged: (value) => amount = value,
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
              onPressed: () => context
                  .read<SessionBloc>()
                  .add(SessionSupplied(amount: amount)),
              icon: const Icon(Icons.check),
              label: const Text('Confirmar'),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
