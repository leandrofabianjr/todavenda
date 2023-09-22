import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/services/services.dart';
import 'package:todavenda/session/widgets/payments_line_chart.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Relatórios'),
              actions: [
                IconButton(
                  onPressed: () => context.go('/relatorios/listagens'),
                  icon: const Icon(Icons.list),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListTile(
                    title: const Text(
                      'Histórico de vendas',
                      textAlign: TextAlign.end,
                    ),
                    subtitle: SizedBox(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                        child: PaymentsLineChart(
                          paymentsRepository:
                              context.read<PaymentsRepository>(),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Produtos mais vendidos',
                      textAlign: TextAlign.end,
                    ),
                    subtitle: ProductSalesChart(
                      salesRepository: context.read<SalesRepository>(),
                    ),
                  ),
                  const SizedBox(height: 80.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
