import 'package:todavenda/sales/models/models.dart';

abstract class PaymentsRepository {
  Future<List<Payment>> load();

  Future<Payment> create({
    required Sale sale,
    required PaymentType type,
    required double value,
  });
}
