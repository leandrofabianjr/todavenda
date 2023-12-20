import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/widgets/widgets.dart';

class FlowPage extends StatelessWidget {
  const FlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Fluxo de Caixa')),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const ListSubtitle(title: 'Cadastros'),
                ListTile(
                  leading: const Icon(Icons.account_balance),
                  title: const Text('Contas'),
                  onTap: () => context.go('/fluxo/contas'),
                ),
                ListTile(
                  leading: const Icon(Icons.sync_alt),
                  title: const Text('Transações'),
                  onTap: () => context.go('/fluxo/transacoes'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
