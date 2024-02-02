import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
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
      dateTimeRange: reportConfig?.dateTimeRange,
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
              bottom: reportConfig == null
                  ? null
                  : AppBar(
                      title: ReportPeriodSelector(
                      reportConfig: reportConfig!,
                      onSelected: (value) {
                        reportConfig = value;
                        reportType = value.type;
                        refresh();
                      },
                    )),
              actions: [
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

class ReportPeriodSelector extends StatelessWidget {
  const ReportPeriodSelector({
    super.key,
    required this.reportConfig,
    required this.onSelected,
  });

  final ReportConfig reportConfig;
  final void Function(ReportConfig config) onSelected;

  List<DropdownMenuItem<ReportConfigType>> get selectedItems =>
      ReportConfigType.values
          .map(
            (t) => DropdownMenuItem(
              value: t,
              child: Text(
                t == ReportConfigType.custom &&
                        reportConfig.type == ReportConfigType.custom
                    ? reportConfig.periodFormatted
                    : t.label,
              ),
            ),
          )
          .toList();

  List<DropdownMenuItem<ReportConfigType>> get items => ReportConfigType.values
      .map(
        (t) => DropdownMenuItem(
          value: t,
          child: Text(t.label),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: reportConfig.type,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.date_range),
        labelText: 'Período',
      ),
      selectedItemBuilder: (context) => selectedItems,
      items: items,
      onChanged: (value) async {
        if (value != null &&
            (value != reportConfig.type || value == ReportConfigType.custom)) {
          final newReportType = value;
          DateTimeRange? newDateTimeRange;
          if (value == ReportConfigType.custom) {
            final last = DateTime.now().lastInstantOfTheDay;
            newDateTimeRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2023),
              lastDate: last,
              initialDateRange: reportConfig.dateTimeRange,
            );
            if (newDateTimeRange != null) {
              newDateTimeRange = DateTimeRange(
                start: newDateTimeRange.start,
                end: newDateTimeRange.end.lastInstantOfTheDay,
              );
            }
          }

          onSelected(reportConfig.copyWith(
            type: newReportType,
            dateTimeRange: newDateTimeRange,
          ));
        }
      },
    );
  }
}
