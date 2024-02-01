import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/data/firebase/firestore_repository.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';
import 'package:todavenda/session/models/models.dart';
import 'package:todavenda/session/services/payments_repository.dart';
import 'package:todavenda/session/services/sessions_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class SalesRepositoryFirestore extends FirestoreRepository<Sale>
    implements SalesRepository {
  var _products = <Product>[];
  var _clients = <Client>[];
  var _payments = <Payment>[];
  var _sessions = <Session>[];

  SalesRepositoryFirestore(
    String companyUuid, {
    required this.productsRepository,
    required this.clientsRepository,
    required this.paymentsRepository,
    required this.sessionsRepository,
  }) : super(companyUuid: companyUuid, resourcePath: 'sales');

  final ProductsRepository productsRepository;
  final ClientsRepository clientsRepository;
  final PaymentsRepository paymentsRepository;
  final SessionsRepository sessionsRepository;

  @override
  fromJson(Map<String, dynamic> json) {
    json['items'] = (json['items'] as List).map((e) {
      e['product'] = _products
          .firstWhere((c) => c.uuid == e['productUuid'])
          .toJson(DateTimeConverterType.firestore);
      return e;
    }).toList();

    json['payments'] = ((json['paymentsUuids'] ?? []) as List)
        .map(
          (e) => _payments
              .firstWhere((c) => c.uuid == e)
              .toJson(DateTimeConverterType.firestore),
        )
        .toList();

    json['client'] = json['clientUuid'] == null
        ? null
        : _clients.firstWhere((c) => c.uuid == json['clientUuid']).toJson();

    json['session'] = _sessions
        .firstWhere((c) => c.uuid == json['sessionUuid'])
        .toJson(DateTimeConverterType.firestore);

    return Sale.fromJson(json, DateTimeConverterType.firestore);
  }

  @override
  Map<String, dynamic> toJson(value) => value.toFirestore();

  Future<void> _updateDependencies() async {
    _products = await productsRepository.loadProducts();
    _clients = await clientsRepository.loadClients();
    _payments = await paymentsRepository.list();
    _sessions = await sessionsRepository.list();
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
      session: session,
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
      {String? sessionUuid, List<DateTime?>? createdBetween}) async {
    await _updateDependencies();

    Query<Sale>? query;

    if (sessionUuid != null) {
      query =
          (query ?? collection).where('sessionUuid', isEqualTo: sessionUuid);
    }
    if (createdBetween != null) {
      query = (query ?? collection).where(
        'createdAt',
        isGreaterThanOrEqualTo: createdBetween.elementAtOrNull(0),
        isLessThanOrEqualTo: createdBetween.elementAtOrNull(1),
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
      sessionUuid: sale.session.uuid,
    );
    _payments.add(payment);
    final newSale = sale.copyWith(
      payments: [...sale.payments, payment],
      amountPaid: sale.calculateAmountPaid(),
    );
    await collection.doc(sale.uuid).set(newSale);

    if (payment.paymentType == PaymentType.onCredit) {
      await clientsRepository.addOwing(sale.client!, payment);
    }

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
