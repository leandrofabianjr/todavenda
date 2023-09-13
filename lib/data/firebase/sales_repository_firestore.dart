import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class SalesRepositoryFirestore extends FirestoreRepository<Sale>
    implements SalesRepository {
  var _sales = <Sale>[];
  var _products = <Product>[];
  var _clients = <Client>[];
  var _payments = <Payment>[];

  SalesRepositoryFirestore(
    String companyUuid, {
    required this.productsRepository,
    required this.clientsRepository,
    required this.paymentsRepository,
  }) : super(companyUuid: companyUuid, resourcePath: 'sales');

  final ProductsRepository productsRepository;
  final ClientsRepository clientsRepository;
  final PaymentsRepository paymentsRepository;

  @override
  fromJson(Map<String, dynamic> json) => Sale.fromJson(
        json,
        _products,
        _clients,
        _payments,
      );

  @override
  Map<String, dynamic> toJson(value) => value.toJson();

  Future<void> _updateDependencies() async {
    _products = await productsRepository.loadProducts();
    _clients = await clientsRepository.loadClients();
    _payments = await paymentsRepository.load();
  }

  @override
  Future<Sale> createSale({
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
      uuid: _uuid.v4(),
      items: saleItems,
      total: saleItems.fold(0, (total, i) => total + i.unitPrice * i.quantity),
      client: client,
      createdAt: DateTime.now(),
    );
    await collection.doc(sale.uuid).set(sale);
    _sales.add(sale);
    return sale;
  }

  @override
  Future<Sale> loadSaleByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data()!;
  }

  @override
  Future<List<Sale>> loadSales() async {
    await _updateDependencies();
    if (_sales.isEmpty) {
      final snapshot = await collection.get();
      _sales = snapshot.docs.map((e) => e.data()).toList();
    }
    return _sales;
  }

  @override
  Future<Sale> addPayment({
    required Sale sale,
    required PaymentType type,
    required double value,
  }) async {
    final payment =
        await paymentsRepository.create(sale: sale, type: type, value: value);
    _payments.add(payment);
    final newSale = sale.copyWith(
      payments: [...sale.payments, payment],
      amountPaid: sale.calculateAmountPaid(),
    );
    await collection.doc(sale.uuid).set(newSale);
    _sales[_sales.indexOf(sale)] = newSale;
    return newSale;
  }

  @override
  Future<void> removeSale(String uuid) async {
    await collection.doc(uuid).delete();
    _sales.removeWhere((element) => element.uuid == uuid);
  }

  @override
  Future<Sale> removePayment({
    required Sale sale,
    required Payment payment,
  }) async {
    await paymentsRepository.remove(payment: payment);
    _payments.remove(payment);
    final payments = sale.payments.where((p) => p != payment).toList();
    final newSale = sale.copyWith(
      payments: payments,
      amountPaid: sale.calculateAmountPaid(),
    );
    await collection.doc(sale.uuid).set(newSale);
    _sales[_sales.indexOf(sale)] = newSale;
    return newSale;
  }
}
