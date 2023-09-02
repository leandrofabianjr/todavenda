import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsMenuPage extends StatelessWidget {
  const ReportsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Relatórios')),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListTile(
                  leading: const Icon(Icons.point_of_sale),
                  title: const Text('Vendas'),
                  onTap: () => context.go('/relatorios/vendas'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
