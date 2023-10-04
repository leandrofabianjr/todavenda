import 'package:collection/collection.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/products/products.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class ProductCategoriesRepositoryFirestore
    extends FirestoreRepository<ProductCategory>
    implements ProductCategoriesRepository {
  var _productCategories = <ProductCategory>[];

  ProductCategoriesRepositoryFirestore(String companyUuid)
      : super(companyUuid: companyUuid, resourcePath: 'productCategories');

  @override
  ProductCategory fromJson(Map<String, dynamic> json) =>
      ProductCategory.fromJson(json);

  @override
  Map<String, dynamic> toJson(ProductCategory value) => value.toJson();

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
    await collection.doc(category.uuid).set(category);
    final index = _productCategories.indexOf(category);
    if (index == -1) {
      _productCategories.add(category);
      _productCategories.sortBy((e) => e.name);
    } else {
      _productCategories[index] = category;
    }
    return category;
  }

  @override
  Future<List<ProductCategory>> load() async {
    if (_productCategories.isEmpty) {
      final snapshot = await collection.get();
      _productCategories = snapshot.docs.map((e) => e.data()).toList();
      _productCategories.sortBy((e) => e.name);
    }
    return _productCategories;
  }

  @override
  Future<ProductCategory> loadByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data()!;
  }

  @override
  Future<void> remove(String uuid) async {
    await collection.doc(uuid).delete();
    _productCategories.removeWhere((e) => e.uuid == uuid);
  }
}
