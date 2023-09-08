import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:todavenda/products/products.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class ProductsRepositoryFirestore implements ProductsRepository {
  static const productsCollectionPath = 'products';
  static const productCategoriesCollectionPath = 'productCategories';

  var _products = <Product>[];
  var _productCategories = <ProductCategory>[];

  CollectionReference<Product?> get productsCollection =>
      FirebaseFirestore.instance
          .collection(productsCollectionPath)
          .withConverter(
            fromFirestore: (snapshot, _) =>
                Product.fromJson(snapshot.data(), _productCategories),
            toFirestore: (value, _) => value?.toJson() ?? {},
          );

  CollectionReference<ProductCategory?> get productCategoriesCollection =>
      FirebaseFirestore.instance
          .collection(productCategoriesCollectionPath)
          .withConverter(
            fromFirestore: (snapshot, _) =>
                ProductCategory.fromJson(snapshot.data()),
            toFirestore: (value, _) => value?.toJson() ?? {},
          );

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
      categories: categories,
      price: price,
      active: true,
    );
    await productsCollection.doc(product.uuid).set(product);
    _products.add(product);
    _products.sortBy((e) => e.description);
    return product;
  }

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
    await productCategoriesCollection.doc(category.uuid).set(category);
    _productCategories.add(category);
    _productCategories.sortBy((e) => e.name);
    return category;
  }

  @override
  Future<Product> loadProductByUuid(String uuid) async {
    final snapshot = await productsCollection.doc(uuid).get();
    return snapshot.data()!;
  }

  @override
  Future<List<ProductCategory>> loadProductCategories({
    required String companyUuid,
  }) async {
    if (_productCategories.isEmpty) {
      final snapshot = await productCategoriesCollection
          .where('companyUuid', isEqualTo: companyUuid)
          .get();
      _productCategories = snapshot.docs.map((e) => e.data()!).toList();
      _productCategories.sortBy((e) => e.name);
    }
    return _productCategories;
  }

  @override
  Future<List<Product>> loadProducts({required String companyUuid}) async {
    await loadProductCategories(companyUuid: companyUuid);
    if (_products.isEmpty) {
      final snapshot = await productsCollection
          .where('companyUuid', isEqualTo: companyUuid)
          .get();
      _products = snapshot.docs.map((e) => e.data()!).toList();
      _products.sortBy((e) => e.description);
    }
    return _products;
  }

  @override
  Future<void> removeProduct(String uuid) async {
    await productsCollection.doc(uuid).delete();
    _products.removeWhere((e) => e.uuid == uuid);
    _products.sortBy((e) => e.description);
  }

  @override
  Future<void> removeProductCategory(String uuid) async {
    await productCategoriesCollection.doc(uuid).delete();
    _productCategories.removeWhere((e) => e.uuid == uuid);
  }
}
