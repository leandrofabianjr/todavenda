import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/sales/sales.dart';

abstract class ClientOnCreditOwingsRepository {
  Future<OnCreditOwingPayment> loadByUuid(String uuid);

  Future<List<OnCreditOwingPayment>> load();

  Future<OnCreditOwingPayment> save({
    String? uuid,
    required String sessionUuid,
    required Client client,
    required double amount,
    required PaymentType paymentType,
  });
}
