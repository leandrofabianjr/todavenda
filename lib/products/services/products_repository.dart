import '../models/product.dart';
import '../models/product_category.dart';

abstract class ProductsRepository {
  Future<Product> loadProductByUuid(String uuid);

  Future<List<Product>> loadProducts();

  Future<Product> saveProduct({
    String? uuid,
    required String description,
    required List<ProductCategory> categories,
    required double price,
  });

  Future<void> removeProduct(String uuid);
}
