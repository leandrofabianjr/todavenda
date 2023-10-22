import 'package:collection/collection.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/data/firebase/product_stock_repository_firestore.dart';
import 'package:todavenda/products/products.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class ProductsRepositoryFirestore extends FirestoreRepository<Product>
    implements ProductsRepository {
  static const productCategoriesCollectionPath = 'productCategories';

  var _products = <Product>[];
  var _productCategories = <ProductCategory>[];

  ProductsRepositoryFirestore(
    String companyUuid, {
    required this.productCategoriesRepository,
  }) : super(companyUuid: companyUuid, resourcePath: 'products');

  final ProductCategoriesRepository productCategoriesRepository;

  @override
  Product fromJson(Map<String, dynamic> json) {
    json['categories'] = json['categoriesUuids'] == null
        ? []
        : (json['categoriesUuids'] as List)
            .map(
              (e) => _productCategories.firstWhere((c) => c.uuid == e).toJson(),
            )
            .toList();
    return Product.fromJson(json, DateTimeConverterType.firestore);
  }

  @override
  Map<String, dynamic> toJson(Product value) =>
      value.toJson(DateTimeConverterType.firestore);

  @override
  Future<Product> saveProduct({
    String? uuid,
    required String description,
    required List<ProductCategory> categories,
    required double price,
    required int currentStock,
    required bool hasStockControl,
    required DateTime createdAt,
  }) async {
    final product = Product(
      uuid: uuid ?? _uuid.v4(),
      description: description,
      categories: categories,
      price: price,
      active: true,
      currentStock: currentStock,
      hasStockControl: hasStockControl,
      createdAt: createdAt,
    );
    await collection.doc(product.uuid).set(product);
    final index = _products.indexOf(product);
    if (index == -1) {
      _products.add(product);
      _products.sortBy((e) => e.description);
    } else {
      _products[index] = product;
    }
    return product;
  }

  @override
  Future<Product> loadProductByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data()!;
  }

  @override
  Future<List<Product>> loadProducts({String? term}) async {
    _productCategories = await productCategoriesRepository.load();

    if (_products.isEmpty) {
      final snapshot = await collection.get();
      _products = snapshot.docs.map((e) => e.data()).toList();
      _products.sortBy((e) => e.description);
    }

    if (term != null) {
      return _products.filterKeyByTerm(key: (p) => p.description, term: term);
    }

    return _products;
  }

  @override
  Future<void> removeProduct(String uuid) async {
    await collection.doc(uuid).delete();
    _products.removeWhere((e) => e.uuid == uuid);
    _products.sortBy((e) => e.description);
  }

  @override
  ProductStockRepository stockRepository(String productUuid) =>
      ProductStockRepositoryFirestore(companyUuid, productUuid: productUuid);

  @override
  Future<Product> updateStock({
    required Product product,
    required int quantity,
  }) async {
    if (!product.hasStockControl) {
      return product;
    }

    int currentStock = product.currentStock + quantity;
    if (currentStock < 0) {
      currentStock = 0;
    }
    await collection.doc(product.uuid).update({'currentStock': currentStock});
    final newProduct = product.copyWith(currentStock: currentStock);
    _products[_products.indexOf(newProduct)] = newProduct;
    return newProduct;
  }
}
