import 'package:todavenda/sales/models/models.dart';

abstract class PaymentsRepository {
  Future<List<Payment>> load({required String saleUuid});

  Future<Payment> create({
    required Sale sale,
    required PaymentType type,
    required double value,
  });

  Future<Payment> remove({required Payment payment});
}
