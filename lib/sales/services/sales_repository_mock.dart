import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/models/payment.dart';
import 'package:uuid/uuid.dart';

import '../models/sale.dart';
import '../models/sale_item.dart';
import '../services/sales_repository.dart';

const _delay = Duration(milliseconds: 800);

var uuid = const Uuid();

final mockPayments = [
  Payment(
    uuid: uuid.v4(),
    type: PaymentType.cash,
    value: 17.95,
    createdAt: DateTime(2023, 8, 31, 14, 32, 23),
  ),
];

final mockSaleItems = [
  SaleItem(
    uuid: uuid.v4(),
    product: mockProducts[0],
    quantity: 1,
    unitPrice: mockProducts[0].price,
  ),
  SaleItem(
    uuid: uuid.v4(),
    product: mockProducts[1],
    quantity: 4,
    unitPrice: mockProducts[1].price,
  ),
  SaleItem(
    uuid: uuid.v4(),
    product: mockProducts[2],
    quantity: 2,
    unitPrice: mockProducts[2].price,
  ),
];

final mockSales = [
  Sale(
    uuid: uuid.v4(),
    items: mockSaleItems.sublist(0, 1),
    total: mockSaleItems
        .sublist(0, 1)
        .fold(0, (total, i) => total + i.unitPrice * i.quantity),
    payments: mockPayments.sublist(0, 0),
    createdAt: DateTime(2023, 8, 31, 14, 38, 23),
  ),
  Sale(
    uuid: uuid.v4(),
    items: mockSaleItems.sublist(2, 2),
    total: mockSaleItems
        .sublist(2, 2)
        .fold(0, (total, i) => total + i.unitPrice * i.quantity),
    createdAt: DateTime(2023, 9, 1, 11, 20, 05),
  ),
];

class SalesRepositoryMock implements SalesRepository {
  final _sales = mockSales;
  final _payments = mockPayments;

  Future<T> _delayed<T>(T Function() callback) {
    return Future.delayed(_delay, callback);
  }

  @override
  Future<Sale> createSale(
      {required Map<Product, int> items, Client? client}) async {
    final saleItems = items.entries.fold<List<SaleItem>>(
      [],
      (saleItems, entry) {
        final product = entry.key;
        final quantity = entry.value;
        final saleItem = SaleItem(
          uuid: uuid.v4(),
          product: product,
          quantity: quantity,
          unitPrice: product.price,
        );
        saleItems.add(saleItem);
        return saleItems;
      },
    );
    final sale = Sale(
      uuid: uuid.v4(),
      items: saleItems,
      total: saleItems.fold(0, (total, i) => total + i.unitPrice * i.quantity),
      client: client,
      createdAt: DateTime.now(),
    );
    await _delayed(() => _sales.add(sale));
    return sale;
  }

  @override
  Future<Sale> loadSaleByUuid(String uuid) {
    return _delayed(() => _sales.firstWhere((s) => s.uuid == uuid));
  }

  @override
  Future<List<Sale>> loadSales() => _delayed(() => _sales);

  @override
  Future<void> removeSale(String uuid) =>
      _delayed(() => _sales.removeWhere((s) => s.uuid == uuid));

  @override
  Future<Sale> newPayment(
    String saleUuid,
    PaymentType type,
    double value,
  ) async {
    final payment = Payment(
      uuid: uuid.v4(),
      type: type,
      value: value,
      createdAt: DateTime.now(),
    );
    _payments.add(payment);

    final saleIndex = _sales.indexWhere((s) => s.uuid == saleUuid);
    final sale = _sales[saleIndex];

    final newSale = Sale(
      uuid: sale.uuid,
      items: sale.items,
      total: sale.total,
      payments: [...sale.payments, payment],
      createdAt: sale.createdAt,
      client: sale.client,
    );
    _sales[saleIndex] = newSale;

    return await _delayed(() => newSale);
  }
}
