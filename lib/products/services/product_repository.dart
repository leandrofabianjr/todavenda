import 'package:todavenda/products/models/product.dart';
import 'package:todavenda/products/models/product_category.dart';

abstract class ProductRepository {
  Future<List<Product>> loadProducts();

  Future<List<ProductCategory>> loadProductCategories();

  void createProduct(Product product);

  void removeProduct(Product product);
}
