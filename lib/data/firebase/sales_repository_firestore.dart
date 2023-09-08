import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class SalesRepositoryFirestore implements SalesRepository {
  static const salesCollectionPath = 'sales';
  static const paymentsCollectionPath = 'payments';

  var _sales = <Sale>[];
  var _products = <Product>[];
  var _clients = <Client>[];
  var _payments = <Payment>[];

  SalesRepositoryFirestore({
    required this.productsRepository,
    required this.clientsRepository,
  });

  final ProductsRepository productsRepository;
  final ClientsRepository clientsRepository;

  CollectionReference<Sale?> get salesCollection =>
      FirebaseFirestore.instance.collection(salesCollectionPath).withConverter(
            fromFirestore: (snapshot, _) => Sale.fromJson(
              snapshot.data(),
              _products,
              _clients,
              _payments,
            ),
            toFirestore: (value, _) => value?.toJson() ?? {},
          );

  CollectionReference<Payment?> get paymentsCollection =>
      FirebaseFirestore.instance
          .collection(paymentsCollectionPath)
          .withConverter(
            fromFirestore: (snapshot, _) => Payment.fromJson(snapshot.data()),
            toFirestore: (value, _) => value?.toJson() ?? {},
          );

  Future<void> _updateDependencies(String companyUuid) async {
    _products = await productsRepository.loadProducts(companyUuid: companyUuid);
    _clients = await clientsRepository.loadClients(companyUuid: companyUuid);
    final snapshot = await paymentsCollection.get();
    _payments = snapshot.docs.map((e) => e.data()!).toList();
  }

  @override
  Future<Sale> createSale({
    required String companyUuid,
    required Map<Product, int> items,
    Client? client,
  }) async {
    final saleItems = items.entries.fold<List<SaleItem>>(
      [],
      (saleItems, entry) {
        final product = entry.key;
        final quantity = entry.value;
        final saleItem = SaleItem(
          uuid: _uuid.v4(),
          product: product,
          quantity: quantity,
          unitPrice: product.price,
        );
        saleItems.add(saleItem);
        return saleItems;
      },
    );
    final sale = Sale(
      companyUuid: companyUuid,
      uuid: _uuid.v4(),
      items: saleItems,
      total: saleItems.fold(0, (total, i) => total + i.unitPrice * i.quantity),
      client: client,
      createdAt: DateTime.now(),
    );
    await salesCollection.doc(sale.uuid).set(sale);
    _sales.add(sale);
    _sales.sortBy((element) => element.createdAt!);
    return sale;
  }

  @override
  Future<Sale> loadSaleByUuid(String uuid) async {
    final snapshot = await salesCollection.doc(uuid).get();
    return snapshot.data()!;
  }

  @override
  Future<List<Sale>> loadSales({required String companyUuid}) async {
    await _updateDependencies(companyUuid);
    if (_sales.isEmpty) {
      final snapshot = await salesCollection.get();
      _sales = snapshot.docs.map((e) => e.data()!).toList();
    }
    return _sales;
  }

  @override
  Future<Sale> newPayment({
    required String companyUuid,
    required Sale sale,
    required PaymentType type,
    required double value,
  }) async {
    final payment = Payment(
      companyUuid: companyUuid,
      uuid: _uuid.v4(),
      type: type,
      value: value,
      createdAt: DateTime.now(),
    );
    await paymentsCollection.doc(payment.uuid).set(payment);
    _payments.add(payment);
    final newSale = sale.copyWith(
      payments: [...sale.payments, payment],
      amountPaid: sale.calculateAmountPaid(),
    );
    await salesCollection.doc(sale.uuid).set(newSale);
    _sales[_sales.indexOf(sale)] = newSale;
    return newSale;
  }

  @override
  Future<void> removeSale(String uuid) async {
    await salesCollection.doc(uuid).delete();
  }
}
