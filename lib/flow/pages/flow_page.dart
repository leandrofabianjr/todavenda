import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/flow/models/flow_account.dart';
import 'package:todavenda/flow/services/flow_accounts_repository.dart';

class FlowDashboardPage extends StatelessWidget {
  const FlowDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Fluxo de Caixa')),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const ListSubtitle(title: 'Totais nas contas'),
                const FlowAccountsDashboardWidget(),
                const ListSubtitle(title: 'Cadastros'),
                ListTile(
                  leading: const Icon(Icons.account_balance),
                  title: const Text('Contas'),
                  onTap: () => context.go('/fluxo/contas'),
                ),
                ListTile(
                  tileColor: colorScheme.primaryContainer,
                  leading: const Icon(Icons.sync_alt),
                  title: const Text('Transações'),
                  onTap: () => context.go('/fluxo/transacoes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlowAccountsDashboardWidget extends StatefulWidget {
  const FlowAccountsDashboardWidget({super.key});

  @override
  State<FlowAccountsDashboardWidget> createState() =>
      _FlowAccountsDashboardWidgetState();
}

class _FlowAccountsDashboardWidgetState
    extends State<FlowAccountsDashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: FutureBuilder<List<FlowAccount>>(
          future: context.read<FlowAccountsRepository>().load(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ExceptionWidget(exception: snapshot.error);
            }
            if (!snapshot.hasData) {
              return const LoadingWidget();
            }
            final accounts = snapshot.data ?? [];
            if (accounts.isEmpty) {
              return const Center(child: Text('Nenhuma conta encontrada'));
            }
            return ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              children: accounts
                  .map((account) => _buildAccountCard(account))
                  .toList(),
            );
          }),
    );
  }

  Widget _buildAccountCard(FlowAccount account) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                account.name,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              Text(
                account.currentAmount.toCurrency(),
                softWrap: true,
                style: textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
