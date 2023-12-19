import 'package:todavenda/sales/sales.dart';

import '../models/models.dart';

abstract interface class PaymentsRepository {
  Future<Payment> create({
    required String sessionUuid,
    required Sale sale,
    required PaymentType paymentType,
    required double amount,
  });

  Future<List<Payment>> list({
    List<String>? uuids,
    String? sessionUuid,
    String? saleUuid,
  });

  Future<SessionMovement?> getByUuid(String uuid);

  Future<void> remove(String? uuid);
}
