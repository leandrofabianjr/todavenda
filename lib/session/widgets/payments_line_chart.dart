import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/session/services/payments_repository.dart';

class PaymentsLineChart extends StatelessWidget {
  const PaymentsLineChart({
    super.key,
    required this.paymentsRepository,
    this.sessionUuid,
  });

  final PaymentsRepository paymentsRepository;
  final String? sessionUuid;

  @override
  Widget build(BuildContext context) {
    return CurrencyAmountVsDateTimeChart(
      getData: () => paymentsRepository.list(
        sessionUuid: sessionUuid,
      ),
      getDateTime: (obj) => obj.createdAt,
      getAmount: (obj) => obj.amount,
      emptyDataWidget: const Center(
        child: Text('Ainda não há vendas realizadas nesta sessão'),
      ),
    );
  }
}
