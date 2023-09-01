import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/models/models.dart';

abstract class SalesRepository {
  Future<Sale> loadSaleByUuid(String uuid);

  Future<List<Sale>> loadSales();

  Future<Sale> createSale({
    required Map<Product, int> items,
  });

  Future<void> removeSale(String uuid);
}
