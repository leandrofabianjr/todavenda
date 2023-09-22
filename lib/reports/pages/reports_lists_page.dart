import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsListsPage extends StatelessWidget {
  const ReportsListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listagens')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.show_chart),
            title: const Text('Vendas'),
            onTap: () => context.go('/relatorios/vendas'),
          ),
          ListTile(
            leading: const Icon(Icons.point_of_sale),
            title: const Text('Sessões de caixa'),
            onTap: () => context.go('/relatorios/sessoes'),
          ),
        ],
      ),
    );
  }
}
