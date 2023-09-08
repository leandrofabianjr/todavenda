import '../models/product.dart';
import '../models/product_category.dart';

abstract class ProductsRepository {
  Future<Product> loadProductByUuid(String uuid);

  Future<List<Product>> loadProducts({required String companyUuid});

  Future<List<ProductCategory>> loadProductCategories({
    required String companyUuid,
  });

  Future<Product> createProduct({
    required String companyUuid,
    required String description,
    required List<ProductCategory> categories,
    required double price,
  });

  Future<void> removeProduct(String uuid);

  Future<ProductCategory> createProductCategory({
    required String companyUuid,
    required String name,
    String? description,
  });

  Future<void> removeProductCategory(String uuid);
}
