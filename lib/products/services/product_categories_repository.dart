import '../models/product_category.dart';

abstract class ProductCategoriesRepository {
  Future<List<ProductCategory>> load();

  Future<ProductCategory> loadByUuid(String uuid);

  Future<ProductCategory> create({required String name, String? description});

  Future<void> remove(String uuid);
}
