import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/payments_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class SalesRepositoryFirestore extends FirestoreRepository<Sale>
    implements SalesRepository {
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
  fromJson(Map<String, dynamic> json) => Sale(
        uuid: json['uuid'],
        items: (json['items'] as List)
            .map((e) => SaleItem.fromJson(e, _products))
            .toList(),
        payments: ((json['paymentsUuids'] ?? []) as List)
            .map((e) => _payments.firstWhere((c) => c.uuid == e))
            .toList(),
        total: json['total'],
        client: json['clientUuid'] == null
            ? null
            : _clients.firstWhere((c) => c.uuid == json['clientUuid']),
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        amountPaid: json['amountPaid'] ?? 0,
        sessionUuid: json['sessionUuid'],
      );

  @override
  Map<String, dynamic> toJson(value) => {
        'uuid': value.uuid,
        'items': value.items.map((e) => e.toJson()).toList(),
        'total': value.total,
        'paymentsUuids': value.payments.map((e) => e.uuid).toList(),
        'clientUuid': value.client?.uuid,
        'createdAt': value.createdAt,
        'amountPaid': value.calculateAmountPaid(),
        'sessionUuid': value.sessionUuid,
      };

  Future<void> _updateDependencies() async {
    _products = await productsRepository.loadProducts();
    _clients = await clientsRepository.loadClients();
    _payments = await paymentsRepository.list();
  }

  @override
  Future<Sale> createSale({
    required Session session,
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
      sessionUuid: session.uuid,
    );
    await collection.doc(sale.uuid).set(sale);
    return sale;
  }

  @override
  Future<Sale> loadSaleByUuid(String uuid) async {
    final snapshot = await collection.doc(uuid).get();
    return snapshot.data()!;
  }

  @override
  Future<List<Sale>> list(
      {String? sessionUuid, List<DateTime>? createdBetween}) async {
    await _updateDependencies();

    Query<Sale>? query;

    if (sessionUuid != null) {
      query =
          (query ?? collection).where('sessionUuid', isEqualTo: sessionUuid);
    }
    if (createdBetween != null) {
      query = (query ?? collection).where(
        'createdAt',
        isGreaterThanOrEqualTo: (createdBetween[0]),
        isLessThanOrEqualTo: (createdBetween[1]),
      );
    }
    final snapshot = await (query ?? collection).get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  @override
  Future<Sale> addPayment({
    required Sale sale,
    required PaymentType type,
    required double amount,
  }) async {
    final payment = await paymentsRepository.create(
      sale: sale,
      paymentType: type,
      amount: amount,
      sessionUuid: sale.sessionUuid,
    );
    _payments.add(payment);
    final newSale = sale.copyWith(
      payments: [...sale.payments, payment],
      amountPaid: sale.calculateAmountPaid(),
    );
    await collection.doc(sale.uuid).set(newSale);
    return newSale;
  }

  @override
  Future<void> remove(Sale sale) async {
    await collection.doc(sale.uuid).delete();
    for (final p in sale.payments) {
      await paymentsRepository.remove(p.uuid);
    }
  }

  @override
  Future<Sale> removePayment({
    required Sale sale,
    required Payment payment,
  }) async {
    await paymentsRepository.remove(payment.uuid);
    _payments.remove(payment);
    final payments = sale.payments.where((p) => p != payment).toList();
    final newSale = sale.copyWith(
      payments: payments,
      amountPaid: sale.calculateAmountPaid(),
    );
    await collection.doc(sale.uuid).set(newSale);
    return newSale;
  }
}
