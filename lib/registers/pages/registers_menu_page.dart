import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistersMenuPage extends StatelessWidget {
  const RegistersMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Cadastros')),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const ListSubtitle(title: 'Produtos'),
                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text('Produtos'),
                  onTap: () => context.go('/cadastros/produtos'),
                ),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Categorias de Produtos'),
                  onTap: () => context.go('/cadastros/produtos/categorias'),
                ),
                const ListSubtitle(title: 'Clientes'),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Clientes'),
                  onTap: () => context.go('/cadastros/clientes'),
                ),
                const ListSubtitle(title: 'Fluxo de caixa'),
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

class ListSubtitle extends StatelessWidget {
  const ListSubtitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: textTheme.titleSmall!.copyWith(color: colorScheme.primary),
      ),
    );
  }
}
