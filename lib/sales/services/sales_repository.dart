import 'package:todavenda/clients/models/client.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/models/models.dart';

abstract class SalesRepository {
  Future<Sale> loadSaleByUuid(String uuid);

  Future<List<Sale>> loadSales();

  Future<Sale> createSale({
    required Map<Product, int> items,
    Client? client,
  });

  Future<void> removeSale(String uuid);

  Future<Sale> addPayment({
    required Sale sale,
    required PaymentType type,
    required double value,
  });
  Future<Sale> removePayment({
    required Sale sale,
    required Payment payment,
  });
}
