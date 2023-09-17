import 'package:todavenda/sales/sales.dart';

import '../models/models.dart';

abstract interface class SessionMovementsRepository {
  Future<Payment> createPayment({
    required String sessionUuid,
    required Sale sale,
    required PaymentType paymentType,
    required double amount,
  });

  Future<SessionSupply> createSupply({
    required String sessionUuid,
    required double amount,
  });

  Future<SessionPickUp> createPickUp({
    required String sessionUuid,
    required double amount,
  });

  Future<List<SessionMovement>> list({
    String? sessionUuid,
    SessionMovementType? type,
    String? saleUuid,
  });

  Future<SessionMovement?> getByUuid(String uuid);

  Future<void> remove(String? uuid);
}
