import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/pages/flow_transaction/bloc/flow_transaction_bloc.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';

class FlowTransactionPage extends StatelessWidget {
  const FlowTransactionPage({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlowTransactionBloc(
        context.read<FlowTransactionsRepository>(),
        uuid: uuid,
      )..add(const FlowTransactionStarted()),
      child: const FlowTransactionView(),
    );
  }
}

class FlowTransactionView extends StatelessWidget {
  const FlowTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<FlowTransactionBloc, FlowTransactionState>(
          builder: (context, state) {
            if (state is FlowTransactionReady) {
              return Text(state.transaction.description);
            }
            return const SizedBox();
          },
        ),
        actions: [
          BlocBuilder<FlowTransactionBloc, FlowTransactionState>(
            builder: (context, state) {
              if (state is FlowTransactionReady) {
                return IconButton(
                  onPressed: () => context.go(
                    '/fluxo/transacoes/${state.transaction.uuid}/editar',
                  ),
                  icon: const Icon(Icons.edit),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<FlowTransactionBloc, FlowTransactionState>(
        builder: (context, state) {
          if (state is FlowTransactionLoading) {
            return const LoadingWidget();
          }

          if (state is FlowTransactionReady) {
            final account = state.transaction;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                DescriptionDetail(
                  description: const Text('Conta'),
                  detail: Text(
                    account.account.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                DescriptionDetail(
                  description: const Text('Tipo'),
                  detail: Text(
                    account.type.label,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                DescriptionDetail(
                  description: const Text('Descrição'),
                  detail: Text(
                    account.description,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                DescriptionDetail(
                  description: const Text('Valor'),
                  detail: Text(
                    account.amount.toCurrency(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                if (account.observation != null)
                  DescriptionDetail(
                    description: const Text('Observação'),
                    detail: Text(
                      account.observation!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
              ],
            );
          }

          return ExceptionWidget(
            exception: state is FlowTransactionException ? state.ex : null,
          );
        },
      ),
    );
  }
}
