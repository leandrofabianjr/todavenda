import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/pages/flow_transaction_list/bloc/flow_transaction_list_bloc.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';

class FlowTransactionListPage extends StatelessWidget {
  const FlowTransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FlowTransactionListBloc(context.read<FlowTransactionsRepository>())
            ..add(const FlowTransactionListStarted()),
      child: const FlowTransactionListView(),
    );
  }
}

class FlowTransactionListView extends StatelessWidget {
  const FlowTransactionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const FlowTransactionListAppBar(),
          BlocBuilder<FlowTransactionListBloc, FlowTransactionListState>(
            builder: (context, state) {
              if (state is FlowTransactionListLoading) {
                return const SliverFillRemaining(child: LoadingWidget());
              }

              if (state is FlowTransactionListReady) {
                final accounts = state.transactions;

                if (accounts.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('Não há transações cadastradas')),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => FlowTransactionListViewTile(
                      state.transactions[index],
                    ),
                    childCount: state.transactions.length,
                  ),
                );
              }

              return SliverFillRemaining(
                child: ExceptionWidget(
                  exception:
                      state is FlowTransactionListException ? state.ex : null,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/fluxo/transacoes/cadastrar').then((value) {
          context
              .read<FlowTransactionListBloc>()
              .add(const FlowTransactionListStarted());
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FlowTransactionListAppBar extends StatelessWidget {
  const FlowTransactionListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      title: Text('Transações'),
      floating: true,
    );
  }
}

class FlowTransactionListViewTile extends StatelessWidget {
  const FlowTransactionListViewTile(this.transaction, {super.key});

  final FlowTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.description),
      subtitle: transaction.observation != null
          ? Text(transaction.observation!)
          : null,
      trailing: Text(transaction.amount.toCurrency()),
      onTap: () => context.go('/fluxo/transacoes/${transaction.uuid}'),
    );
  }
}
