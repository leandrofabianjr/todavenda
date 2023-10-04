import 'package:collection/collection.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/data/firebase/product_stock_repository_firestore.dart';
import 'package:todavenda/products/products.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

extension DiacriticsAwareString on String {
  static const diacritics =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËĚèéêëěðČÇçčÐĎďÌÍÎÏìíîïĽľÙÚÛÜŮùúûüůŇÑñňŘřŠšŤťŸÝÿýŽž';
  static const nonDiacritics =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEEeeeeeeCCccDDdIIIIiiiiLlUUUUUuuuuuNNnnRrSsTtYYyyZz';

  String get withoutDiacriticalMarks => splitMapJoin('',
      onNonMatch: (char) => char.isNotEmpty && diacritics.contains(char)
          ? nonDiacritics[diacritics.indexOf(char)]
          : char);
}

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
  Product fromJson(Map<String, dynamic> json) =>
      Product.fromJson(json, _productCategories);

  @override
  Map<String, dynamic> toJson(Product value) => value.toJson();

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
      categories: categories,
      price: price,
      active: true,
      currentStock: currentStock,
      hasStockControl: hasStockControl,
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
      final filteredTerm = term.withoutDiacriticalMarks;
      final containsTerm = _products
          .where(
            (p) => p.description.withoutDiacriticalMarks.contains(
              RegExp(filteredTerm, caseSensitive: false),
            ),
          )
          .toList();
      final startsWith = containsTerm
          .where(
            (p) => p.description.withoutDiacriticalMarks.startsWith(
              RegExp('^$filteredTerm', caseSensitive: false),
            ),
          )
          .toList();
      containsTerm.removeWhere((e) => startsWith.contains(e));
      return [...startsWith, ...containsTerm];
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
  ProductStockRepository stockRepository(Product product) =>
      ProductStockRepositoryFirestore(companyUuid, productUuid: product.uuid!);

  @override
  Future<Product> updateStock({
    required Product product,
    required int quantity,
  }) async {
    if (!product.hasStockControl) {
      return product;
    }

    final currentStock = product.currentStock + quantity;
    await collection.doc(product.uuid).update({'currentStock': currentStock});
    final newProduct = product.copyWith(currentStock: currentStock);
    _products[_products.indexOf(newProduct)] = newProduct;
    return newProduct;
  }
}
