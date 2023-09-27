import 'package:collection/collection.dart';
import 'package:todavenda/products/products.dart';
import 'package:uuid/uuid.dart';

import 'product_categories_repository_mock.dart';

const _delay = Duration(milliseconds: 800);

const _uuid = Uuid();

final mockProducts = [
  Product(
    uuid: _uuid.v4(),
    description: 'Pão de forma',
    price: 5.99,
    categories: [mockProductCategories[0]],
  ),
  Product(
    uuid: _uuid.v4(),
    description: 'Café',
    price: 2.99,
    categories: [mockProductCategories[1]],
  ),
  Product(
    uuid: _uuid.v4(),
    description: 'Água',
    price: 2,
    categories: [mockProductCategories[1]],
  ),
];

class ProductsRepositoryMock implements ProductsRepository {
  final _products = mockProducts;

  Future<T> _delayed<T>(T Function() callback) {
    return Future.delayed(_delay, callback);
  }

  @override
  Future<Product> loadProductByUuid(String uuid) async =>
      _delayed(() => _products.firstWhere((p) => p.uuid == uuid));

  @override
  Future<List<Product>> loadProducts() => _delayed(() => _products);

  @override
  Future<Product> saveProduct({
    String? uuid,
    required String description,
    required List<ProductCategory> categories,
    required double price,
  }) async {
    final product = Product(
      uuid: uuid ?? _uuid.v4(),
      description: description,
      price: price,
      categories: categories,
    );
    final index = _products.indexOf(product);
    if (index == -1) {
      _products.add(product);
      _products.sortBy((e) => e.description);
    } else {
      _products[index] = product;
    }
    return await _delayed(() => product);
  }

  @override
  Future<void> removeProduct(String uuid) async =>
      _delayed(() => _products.removeWhere((p) => p.uuid == uuid));
}
