import 'package:todavenda/products/products.dart';
import 'package:uuid/uuid.dart';

const _delay = Duration(milliseconds: 800);

const _uuid = Uuid();

final mockProductCategories = [
  ProductCategory(
    companyUuid: '',
    uuid: _uuid.v4(),
    name: 'Padaria',
    description: 'Um monte de glúten',
  ),
  ProductCategory(
    companyUuid: '',
    uuid: _uuid.v4(),
    name: 'Bebidas',
    description: 'Líquidos pra beber',
  ),
];

final mockProducts = [
  Product(
    companyUuid: '',
    uuid: _uuid.v4(),
    description: 'Pão de forma',
    price: 5.99,
    categories: [mockProductCategories[0]],
  ),
  Product(
    companyUuid: '',
    uuid: _uuid.v4(),
    description: 'Café',
    price: 2.99,
    categories: [mockProductCategories[1]],
  ),
  Product(
    companyUuid: '',
    uuid: _uuid.v4(),
    description: 'Água',
    price: 2,
    categories: [mockProductCategories[1]],
  ),
];

class ProductsRepositoryMock implements ProductsRepository {
  final _products = mockProducts;
  final _productCategories = mockProductCategories;

  Future<T> _delayed<T>(T Function() callback) {
    return Future.delayed(_delay, callback);
  }

  @override
  Future<Product> loadProductByUuid(String uuid) async =>
      _delayed(() => _products.firstWhere((p) => p.uuid == uuid));

  @override
  Future<List<Product>> loadProducts({required String companyUuid}) =>
      _delayed(() => _products);

  @override
  Future<List<ProductCategory>> loadProductCategories(
          {required String companyUuid}) =>
      _delayed(() => _productCategories);

  @override
  Future<Product> createProduct({
    required String companyUuid,
    required String description,
    required List<ProductCategory> categories,
    required double price,
  }) async {
    final product = Product(
      companyUuid: companyUuid,
      uuid: _uuid.v4(),
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

  @override
  Future<ProductCategory> createProductCategory({
    required String companyUuid,
    required String name,
    String? description,
  }) async {
    final category = ProductCategory(
      companyUuid: companyUuid,
      uuid: _uuid.v4(),
      name: name,
      description: description,
    );
    await _delayed(() => _productCategories.add(category));
    return category;
  }

  @override
  Future<void> removeProductCategory(String uuid) =>
      _delayed(() => _productCategories.removeWhere((p) => p.uuid == uuid));
}
