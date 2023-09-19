import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';

class SessionSummaryPage extends StatelessWidget {
  const SessionSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/vender'),
          ),
          title: const Text('Caixa atual')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DescriptionDetail(
                  description: const Text('Em caixa'),
                  detail: Text('R\$ 999,99', style: textTheme.titleLarge),
                ),
                DescriptionDetail(
                  description: const Text('Suprimentos'),
                  detail: Text('R\$ 999,99', style: textTheme.titleLarge),
                ),
                DescriptionDetail(
                  description: const Text('Sangrias'),
                  detail: Text('R\$ 999,99', style: textTheme.titleLarge),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Divider(),
              const Text('Histórico'),
              ListTile(
                onTap: () => context.go('/caixa/fluxo'),
                leading: const Icon(Icons.compare_arrows),
                title: const Text('Ver fluxo'),
              ),
            ],
          ),
          Column(
            children: [
              const Divider(),
              const Text('Operações'),
              ListTile(
                onTap: () => context.go('/caixa/suprimento'),
                leading: const Icon(Icons.login),
                title: const Text('Suprimento'),
              ),
              ListTile(
                onTap: () => context.go('/caixa/sangria'),
                leading: const Icon(Icons.logout),
                title: const Text('Sangria'),
              ),
              ListTile(
                onTap: () => context.go('/caixa/fechamento'),
                leading: const Icon(Icons.archive_outlined),
                title: const Text('Fechamento'),
                textColor: colorScheme.error,
                iconColor: colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
