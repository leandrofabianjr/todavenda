import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/session/services/payments_repository.dart';

class PaymentsLineChart extends StatelessWidget {
  const PaymentsLineChart(
      {super.key, required this.paymentsRepository, this.sessionUuid});

  final PaymentsRepository paymentsRepository;
  final String? sessionUuid;

  @override
  Widget build(BuildContext context) {
    return CurrencyAmountVsDateTimeChart(
      getData: () async {
        final payments = await paymentsRepository.list(
          sessionUuid: sessionUuid,
        );
        payments.sortBy((p) => p.createdAt);
        return payments;
      },
      getDateTime: (obj) => obj.createdAt,
      getAmount: (obj) => obj.amount,
      emptyDataWidget: const Center(
        child: Text('Ainda não há vendas realizadas nesta sessão'),
      ),
    );
  }
}
