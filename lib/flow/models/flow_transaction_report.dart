import 'package:collection/collection.dart';
import 'package:todavenda/commons/commons.dart';

import 'flow_transaction.dart';

class FlowTransactionReportPeriod {
  const FlowTransactionReportPeriod({
    required this.from,
    required this.to,
    required this.label,
  });

  final DateTime from;
  final DateTime to;
  final String label;
}

class FlowTransactionReport {
  const FlowTransactionReport({
    required this.transactions,
  });

  final List<FlowTransaction> transactions;

  List<FlowTransactionReportByDay> get byDay {
    final transactionsByDay = <DateTime, List<FlowTransaction>>{};

    for (final transaction in transactions) {
      transactionsByDay
          .putIfAbsent(
            transaction.createdAt.firstInstantOfTheDay,
            () => [],
          )
          .add(transaction);
    }

    final reportsByDay = transactionsByDay.entries
        .sorted((a, b) => -a.key.compareTo(b.key))
        .map((e) => FlowTransactionReportByDay(
              date: e.key,
              transactions: e.value,
            ))
        .toList();

    return reportsByDay;
  }

  List<FlowTransactionReportByMonth> get byMonth {
    final reportsByMonth = <DateTime, List<FlowTransactionReportByDay>>{};

    for (var byDayReport in byDay) {
      reportsByMonth
          .putIfAbsent(
            byDayReport.date.firstInstantOfTheMonth,
            () => [],
          )
          .add(byDayReport);
    }

    final reportsByMonthList = reportsByMonth.entries
        .sorted((a, b) => -a.key.compareTo(b.key))
        .map((e) => FlowTransactionReportByMonth(
              date: e.key,
              byDayReports: e.value,
            ))
        .toList();

    return reportsByMonthList;
  }

  List<FlowTransactionReportPeriod> get availablePeriods {
    final periods = <DateTime, dynamic>{};

    final sortedList = transactions.sortedBy((t) => t.createdAt);

    for (final transaction in sortedList) {
      periods.putIfAbsent(
        transaction.createdAt.firstInstantOfTheMonth,
        () => [],
      );
    }

    final reportsByDay = periods.keys
        .map((date) => FlowTransactionReportPeriod(
              from: date,
              to: date.lastInstantOfTheMonth,
              label: date.monthName,
            ))
        .toList();

    return reportsByDay;
  }
}

class FlowTransactionReportByDay {
  const FlowTransactionReportByDay({
    required this.date,
    required this.transactions,
  });

  final DateTime date;
  final List<FlowTransaction> transactions;

  double get totalIncoming {
    return transactions.fold(0.0, (total, t) {
      if (t.type == FlowTransactionType.incoming) {
        return total + t.amount;
      }
      return total;
    });
  }

  double get totalOutgoing {
    return transactions.fold(0.0, (total, t) {
      if (t.type == FlowTransactionType.outgoing) {
        return total + t.amount;
      }
      return total;
    });
  }
}

class FlowTransactionReportByMonth {
  const FlowTransactionReportByMonth({
    required this.date,
    required this.byDayReports,
  });

  final DateTime date;
  final List<FlowTransactionReportByDay> byDayReports;

  double get totalIncoming {
    return byDayReports.fold(0.0, (total, t) {
      return total + t.totalIncoming;
    });
  }

  double get totalOutgoing {
    return byDayReports.fold(0.0, (total, t) {
      return total + t.totalOutgoing;
    });
  }
}
