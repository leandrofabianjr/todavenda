import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/session/services/payments_repository.dart';
import 'package:todavenda/session/session.dart';

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
                PaymentsLineChart(
                  paymentsRepository: context.read<PaymentsRepository>(),
                ),
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
          ),
        ],
      ),
    );
  }
}
