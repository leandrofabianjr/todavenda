import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/widgets/exception_widget.dart';
import 'package:todavenda/commons/widgets/loading_widget.dart';
import 'package:todavenda/flow/models/flow_account.dart';
import 'package:todavenda/flow/pages/flow_account_list/bloc/flow_account_list_bloc.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';

class FlowAccountListPage extends StatelessWidget {
  const FlowAccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FlowAccountListBloc(context.read<FlowAccountsRepository>())
            ..add(const FlowAccountListStarted()),
      child: const FlowAccountListView(),
    );
  }
}

class FlowAccountListView extends StatelessWidget {
  const FlowAccountListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const FlowAccountListAppBar(),
          BlocBuilder<FlowAccountListBloc, FlowAccountListState>(
            builder: (context, state) {
              if (state is FlowAccountListLoading) {
                return const SliverFillRemaining(child: LoadingWidget());
              }

              if (state is FlowAccountListReady) {
                final accounts = state.accounts;

                if (accounts.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('Não há contas cadastradas')),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => FlowAccountListViewTile(
                      state.accounts[index],
                    ),
                    childCount: state.accounts.length,
                  ),
                );
              }

              return SliverFillRemaining(
                child: ExceptionWidget(
                  exception:
                      state is FlowAccountListException ? state.ex : null,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/fluxo/contas/cadastrar').then((value) {
          context
              .read<FlowAccountListBloc>()
              .add(const FlowAccountListStarted());
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FlowAccountListAppBar extends StatelessWidget {
  const FlowAccountListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      title: Text('Contas'),
      floating: true,
    );
  }
}

class FlowAccountListViewTile extends StatelessWidget {
  const FlowAccountListViewTile(this.account, {super.key});

  final FlowAccount account;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(account.name),
      subtitle: account.description != null ? Text(account.description!) : null,
      onTap: () => context.go('/fluxo/contas/${account.uuid}'),
    );
  }
}
