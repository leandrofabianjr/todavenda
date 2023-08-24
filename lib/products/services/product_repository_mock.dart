import 'package:todavenda/products/models/product.dart';
import 'package:todavenda/products/models/product_category.dart';
import 'package:todavenda/products/services/product_repository.dart';
import 'package:uuid/uuid.dart';

const _delay = Duration(milliseconds: 800);

var uuid = const Uuid();

final _dataProductCategories = [
  ProductCategory(
      id: uuid.v4(), name: 'Padaria', description: 'Um monte de glúten'),
  ProductCategory(
      id: uuid.v4(), name: 'Bebidas', description: 'Líquidos pra beber'),
];

final _dataProducts = [
  Product(
    id: uuid.v4(),
    description: 'Pão de forma',
    price: 5.99,
    categories: [_dataProductCategories[0]],
  ),
  Product(
    id: uuid.v4(),
    description: 'Café',
    price: 2.99,
    categories: [_dataProductCategories[1]],
  ),
  Product(
    id: uuid.v4(),
    description: 'Água',
    price: 2,
    categories: [_dataProductCategories[1]],
  ),
];

class ProductRepositoryMock implements ProductRepository {
  final _products = _dataProducts;
  final _productCategories = _dataProductCategories;

  @override
  Future<List<Product>> loadProducts() =>
      Future.delayed(_delay, () => _products);

  @override
  Future<List<ProductCategory>> loadProductCategories() =>
      Future.delayed(_delay, () => _productCategories);

  @override
  void createProduct(Product product) =>
      Future.delayed(_delay, () => _products.add(product));

  @override
  void removeProduct(Product product) =>
      Future.delayed(_delay, () => _products.remove(product));
}
