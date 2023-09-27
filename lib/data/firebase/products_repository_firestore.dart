import 'package:collection/collection.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
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
  }) async {
    final product = Product(
      uuid: uuid ?? _uuid.v4(),
      description: description,
      categories: categories,
      price: price,
      active: true,
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
  Future<List<Product>> loadProducts() async {
    _productCategories = await productCategoriesRepository.load();
    if (_products.isEmpty) {
      final snapshot = await collection.get();
      _products = snapshot.docs.map((e) => e.data()).toList();
      _products.sortBy((e) => e.description);
    }
    return _products;
  }

  @override
  Future<void> removeProduct(String uuid) async {
    await collection.doc(uuid).delete();
    _products.removeWhere((e) => e.uuid == uuid);
    _products.sortBy((e) => e.description);
  }
}
