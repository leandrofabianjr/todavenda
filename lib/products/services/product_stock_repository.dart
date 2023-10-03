import 'package:todavenda/products/products.dart';

abstract class ProductStockRepository {
  Future<List<ProductStock>> load();

  Future<ProductStock> save({
    required int quantity,
    required DateTime createdAt,
    required String? observation,
  });

  Future<void> remove(String uuid);
}
