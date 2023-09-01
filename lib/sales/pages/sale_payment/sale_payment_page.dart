import 'package:flutter/material.dart';

class SalePaymentPage extends StatelessWidget {
  const SalePaymentPage({
    super.key,
    required this.saleUuid,
  });

  final String saleUuid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Text(saleUuid),
    );
  }
}
