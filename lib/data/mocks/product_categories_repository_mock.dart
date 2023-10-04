import 'package:collection/collection.dart';
import 'package:todavenda/products/products.dart';
import 'package:uuid/uuid.dart';

const _delay = Duration(milliseconds: 800);

const _uuid = Uuid();

final mockProductCategories = [
  ProductCategory(
    uuid: _uuid.v4(),
    name: 'Padaria',
    description: 'Um monte de glúten',
  ),
  ProductCategory(
    uuid: _uuid.v4(),
    name: 'Bebidas',
    description: 'Líquidos pra beber',
  ),
];

class ProductCategoriesRepositoryMock implements ProductCategoriesRepository {
  final _productCategories = mockProductCategories;

  Future<T> _delayed<T>(T Function() callback) {
    return Future.delayed(_delay, callback);
  }

  @override
  Future<List<ProductCategory>> load() => _delayed(() => _productCategories);

  @override
  Future<ProductCategory> loadByUuid(String uuid) async =>
      _delayed(() => _productCategories.firstWhere((p) => p.uuid == uuid));

  @override
  Future<ProductCategory> save({
    String? uuid,
    required String name,
    String? description,
  }) async {
    final category = ProductCategory(
      uuid: uuid ?? _uuid.v4(),
      name: name,
      description: description,
    );
    final index = _productCategories.indexOf(category);
    if (index == -1) {
      _productCategories.add(category);
      _productCategories.sortBy((e) => e.name);
    } else {
      _productCategories[index] = category;
    }
    return await _delayed(() => category);
  }

  @override
  Future<void> remove(String uuid) =>
      _delayed(() => _productCategories.removeWhere((p) => p.uuid == uuid));
}
