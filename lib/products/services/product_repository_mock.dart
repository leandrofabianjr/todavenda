import 'package:uuid/uuid.dart';

import '../models/product.dart';
import '../models/product_category.dart';
import '../services/product_repository.dart';

const _delay = Duration(milliseconds: 800);

var uuid = const Uuid();

final _dataProductCategories = [
  ProductCategory(
      uuid: uuid.v4(), name: 'Padaria', description: 'Um monte de glúten'),
  ProductCategory(
      uuid: uuid.v4(), name: 'Bebidas', description: 'Líquidos pra beber'),
];

final _dataProducts = [
  Product(
    uuid: uuid.v4(),
    description: 'Pão de forma',
    price: 5.99,
    categories: [_dataProductCategories[0]],
  ),
  Product(
    uuid: uuid.v4(),
    description: 'Café',
    price: 2.99,
    categories: [_dataProductCategories[1]],
  ),
  Product(
    uuid: uuid.v4(),
    description: 'Água',
    price: 2,
    categories: [_dataProductCategories[1]],
  ),
];

class ProductRepositoryMock implements ProductRepository {
  final _products = _dataProducts;
  final _productCategories = _dataProductCategories;

  @override
  Future<Product> loadProductByUuid(String uuid) async =>
      _delayed(() => _products.firstWhere((p) => p.uuid == uuid));

  Future<T> _delayed<T>(T Function() callback) {
    return Future.delayed(_delay, callback);
  }

  @override
  Future<List<Product>> loadProducts() => _delayed(() => _products);

  @override
  Future<List<ProductCategory>> loadProductCategories() =>
      _delayed(() => _productCategories);

  @override
  Future<Product> createProduct({
    required String description,
    required List<ProductCategory> categories,
    required double price,
  }) async {
    final product = Product(
      uuid: uuid.v4(),
      description: description,
      price: price,
      categories: categories,
    );
    await _delayed(() => _products.add(product));
    return product;
  }

  @override
  Future<void> removeProduct(String uuid) async =>
      _delayed(() => _products.removeWhere((p) => p.uuid == uuid));
}
