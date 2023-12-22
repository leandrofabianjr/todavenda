import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/flow/models/flow_transaction.dart';
import 'package:todavenda/flow/pages/flow_page/bloc/flow_bloc.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';
import 'package:todavenda/flow/services/flow_transactions_repository.dart';

class FlowPage extends StatelessWidget {
  const FlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlowBloc(
        flowAccountsRepository: context.read<FlowAccountsRepository>(),
        flowTransactionsRepository: context.read<FlowTransactionsRepository>(),
      )..add(const FlowRefreshed()),
      child: const FlowView(),
    );
  }
}

class FlowView extends StatefulWidget {
  const FlowView({super.key});

  @override
  State<FlowView> createState() => _FlowViewState();
}

class _FlowViewState extends State<FlowView> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<FlowBloc>().add(const FlowRefreshed()),
      child: Scaffold(
        appBar: const FlowAppBar(),
        body: BlocBuilder<FlowBloc, FlowState>(
          builder: (context, state) {
            switch (state.status) {
              case FlowStatus.loading:
                return const LoadingWidget();
              case FlowStatus.loaded:
                return ListView(
                  children: [
                    ...state.transactionsReport!.byDay.map<Widget>(
                      (dayReport) {
                        return ExpansionTile(
                            initiallyExpanded: true,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateTimeFormatter.shortDate(dayReport.date),
                                  style: TextStyle(color: colorScheme.primary),
                                ),
                                Text(
                                  dayReport.totalIncoming.toCurrency(),
                                  style: TextStyle(
                                    color: FlowTransactionType.incoming.color,
                                  ),
                                ),
                                Text(
                                  dayReport.totalOutgoing.toCurrency(),
                                  style: TextStyle(
                                    color: FlowTransactionType.outgoing.color,
                                  ),
                                ),
                              ],
                            ),
                            children: dayReport.transactions
                                .map(
                                  (transaction) => FlowTransactionListTile(
                                    transaction,
                                  ),
                                )
                                .toList());
                      },
                    ).toList(),
                    const SizedBox(height: 80),
                  ],
                );
              case FlowStatus.failure:
                return ExceptionWidget(exception: state.ex);
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/fluxo/transacoes/cadastrar').then(
                (value) => context.read<FlowBloc>().add(const FlowRefreshed()),
              ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class FlowTransactionListTile extends StatelessWidget {
  const FlowTransactionListTile(this.transaction, {super.key});

  final FlowTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: transaction.type.color, width: 8.0),
        ),
      ),
      child: ListTile(
        title: Text(transaction.description),
        subtitle: transaction.observation != null
            ? Text(transaction.observation!)
            : null,
        trailing: Text(
          (transaction.type == FlowTransactionType.outgoing ? '- ' : '') +
              transaction.amount.toCurrency(),
          style: textTheme.titleLarge?.copyWith(
            color: transaction.type.color,
          ),
        ),
        onTap: () => context.go('/fluxo/transacoes/${transaction.uuid}'),
      ),
    );
  }
}

class FlowAppBar extends StatefulWidget implements PreferredSizeWidget {
  const FlowAppBar({super.key});

  @override
  State<FlowAppBar> createState() => _FlowAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);
}

class _FlowAppBarState extends State<FlowAppBar> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlowBloc, FlowState>(
      builder: (context, state) {
        if (state.status == FlowStatus.loaded) {
          final availablePeriods = state.transactionsReport!.availablePeriods;
          _tabController = TabController(
            length: availablePeriods.length,
            vsync: this,
          );
          return AppBarWithSearchView(
            onSearchChanged: (term) {
              final filter = state.filter.copyWith(searchTerm: term);
              context.read<FlowBloc>().add(FlowRefreshed(filter: filter));
            },
            initialSearchTerm: state.filter.searchTerm,
            title: const Text('Transações'),
            bottom: TabBar(
              controller: _tabController,
              tabs: availablePeriods
                  .map(
                    (period) => Tab(child: Text(period.label)),
                  )
                  .toList(),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
