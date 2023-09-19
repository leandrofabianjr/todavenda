import 'package:todavenda/clients/models/client.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/models/models.dart';
import 'package:todavenda/session/models/models.dart';

abstract class SalesRepository {
  Future<Sale> loadSaleByUuid(String uuid);

  Future<List<Sale>> list({String? sessionUuid});

  Future<Sale> createSale({
    required Session session,
    required Map<Product, int> items,
    Client? client,
  });

  Future<void> remove(Sale sale);

  Future<Sale> addPayment({
    required Sale sale,
    required PaymentType type,
    required double amount,
  });
  Future<Sale> removePayment({
    required Sale sale,
    required Payment payment,
  });
}
