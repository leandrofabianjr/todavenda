import '../models/product.dart';
import '../models/product_category.dart';

abstract class ProductsRepository {
  Future<Product> loadProductByUuid(String uuid);

  Future<List<Product>> loadProducts();

  Future<List<ProductCategory>> loadProductCategories();

  Future<Product> createProduct({
    required String description,
    required List<ProductCategory> categories,
    required double price,
  });

  Future<void> removeProduct(String uuid);

  Future<ProductCategory> createProductCategory({
    required String name,
    required String? description,
  });

  Future<void> removeProductCategory(String uuid);
}
