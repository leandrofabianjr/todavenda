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
    currentStock: 4,
    hasStockControl: true,
  ),
  Product(
    uuid: _uuid.v4(),
    description: 'Café',
    price: 2.99,
    categories: [mockProductCategories[1]],
    currentStock: 5,
    hasStockControl: true,
  ),
  Product(
    uuid: _uuid.v4(),
    description: 'Água',
    price: 2,
    categories: [mockProductCategories[1]],
    currentStock: 0,
    hasStockControl: false,
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
  Future<List<Product>> loadProducts({String? term}) => _delayed(() {
        if (term != null) {
          return _products
              .where((p) =>
                  p.description.contains(RegExp(term, caseSensitive: false)))
              .toList();
        }
        return _products;
      });

  @override
  Future<Product> saveProduct({
    String? uuid,
    required String description,
    required List<ProductCategory> categories,
    required double price,
    required int currentStock,
    required bool hasStockControl,
  }) async {
    final product = Product(
      uuid: uuid ?? _uuid.v4(),
      description: description,
      price: price,
      categories: categories,
      currentStock: currentStock,
      hasStockControl: hasStockControl,
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

  @override
  ProductStockRepository stockRepository(String productUuid) {
    throw UnimplementedError();
  }

  @override
  Future<Product> updateStock(
      {required Product product, required int quantity}) async {
    final currentStock = product.currentStock + quantity;
    final newProduct = product.copyWith(currentStock: currentStock);
    final index = _products.indexOf(newProduct);
    if (index == -1) {
      _products.add(newProduct);
      _products.sortBy((e) => e.description);
    } else {
      _products[index] = newProduct;
    }
    return await _delayed(() => newProduct);
  }
}
