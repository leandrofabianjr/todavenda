import 'package:todavenda/products/products.dart';

abstract class ProductsRepository {
  Future<Product> loadProductByUuid(String uuid);

  Future<List<Product>> loadProducts({String? term});

  Future<Product> saveProduct({
    String? uuid,
    required String description,
    required List<ProductCategory> categories,
    required double price,
    required int currentStock,
    required bool hasStockControl,
  });

  Future<Product> updateStock({
    required Product product,
    required int quantity,
  });

  Future<void> removeProduct(String uuid);

  ProductStockRepository stockRepository(Product product);
}
