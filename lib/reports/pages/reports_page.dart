import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/reports/reports.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/widgets/payments_bar_chart.dart';
import 'package:todavenda/session/widgets/payments_by_type_pie_chart.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late final SalesRepository salesRepository;
  var reportType = ReportConfigType.today;
  ReportConfig? reportConfig;

  @override
  void initState() {
    salesRepository = context.read<SalesRepository>();
    SchedulerBinding.instance.addPostFrameCallback((_) => refresh());
    super.initState();
  }

  Future<void> updateSalesData() async {
    reportConfig = await ReportConfig.fromType(
      salesRepository: salesRepository,
      reportType: reportType,
    );
    setState(() {});
  }

  void refresh() {
    _refreshIndicatorKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: updateSalesData,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Relatórios'),
              actions: [
                ReportPeriodSelector(
                  onSelected: (value) {
                    reportType = value;
                    refresh();
                  },
                ),
                IconButton(
                  onPressed: () => context.go('/relatorios/listagens'),
                  icon: const Icon(Icons.list),
                )
              ],
            ),
            if (reportConfig != null)
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ListTile(
                      title: const Text(
                        'Pagamentos por tipo',
                        textAlign: TextAlign.end,
                      ),
                      subtitle: SizedBox(
                        width: double.maxFinite,
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: PaymentsByTypePieChart(
                            config: reportConfig!,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        'Histórico de vendas',
                        textAlign: TextAlign.end,
                      ),
                      subtitle: SizedBox(
                        width: double.maxFinite,
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: PaymentsBarChart(
                            config: reportConfig!,
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
                        config: reportConfig!,
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

class ReportPeriodSelector extends StatefulWidget {
  const ReportPeriodSelector({
    super.key,
    this.reportType,
    required this.onSelected,
  });

  final ReportConfigType? reportType;
  final void Function(ReportConfigType value) onSelected;

  @override
  State<ReportPeriodSelector> createState() => _ReportPeriodSelectorState();
}

class _ReportPeriodSelectorState extends State<ReportPeriodSelector> {
  late ReportConfigType reportType;

  @override
  void initState() {
    reportType = widget.reportType ?? ReportConfigType.today;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: 160,
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.zero,
      ),
      initialSelection: reportType,
      dropdownMenuEntries: const [
        DropdownMenuEntry(
          value: ReportConfigType.today,
          label: 'Hoje',
        ),
        DropdownMenuEntry(
          value: ReportConfigType.last24hours,
          label: 'Últimas 24 horas',
        ),
        DropdownMenuEntry(
          value: ReportConfigType.last7Days,
          label: 'Últimos 7 dias',
        ),
        DropdownMenuEntry(
          value: ReportConfigType.last30Days,
          label: 'Últimos 30 dias',
        ),
      ],
      onSelected: (value) {
        setState(() => reportType = value!);
        widget.onSelected(value!);
      },
    );
  }
}
