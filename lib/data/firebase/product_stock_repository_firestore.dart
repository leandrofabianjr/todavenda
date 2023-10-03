import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/products/products.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class ProductStockRepositoryFirestore extends FirestoreRepository<ProductStock>
    implements ProductStockRepository {
  static const productStockCollectionPath = 'stock';

  ProductStockRepositoryFirestore(
    String companyUuid, {
    required String productUuid,
  }) : super(
            companyUuid: companyUuid,
            resourcePath: 'products/$productUuid/stocks');

  @override
  Map<String, dynamic> toJson(ProductStock value) {
    return {
      'uuid': value.uuid,
      'quantity': value.quantity,
      'createdAt': value.createdAt,
      'observation': value.observation,
    };
  }

  @override
  ProductStock fromJson(Map<String, dynamic> json) {
    return ProductStock(
      uuid: json['uuid'],
      quantity: json['quantity'],
      observation: json['observation'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  @override
  Future<List<ProductStock>> load() async {
    final snapshot = await collection.get();
    final list = snapshot.docs.map((e) => e.data()).toList();
    list.sortBy((e) => e.createdAt);
    return list;
  }

  @override
  Future<void> remove(String uuid) async {
    await collection.doc(uuid).delete();
  }

  @override
  Future<ProductStock> save({
    required int quantity,
    required DateTime createdAt,
    required String? observation,
  }) async {
    final productStock = ProductStock(
      uuid: _uuid.v4(),
      createdAt: createdAt,
      quantity: quantity,
      observation: observation,
    );
    await collection.doc(productStock.uuid).set(productStock);
    return productStock;
  }
}
