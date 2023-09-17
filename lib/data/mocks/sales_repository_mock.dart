// import 'package:todavenda/clients/clients.dart';
// import 'package:todavenda/products/products.dart';
// import 'package:todavenda/sales/sales.dart';
// import 'package:uuid/uuid.dart';

// import 'clients_repository_mock.dart';
// import 'products_repository_mock.dart';

// const _delay = Duration(milliseconds: 800);

// const _uuid = Uuid();

// final mockPayments = [
//   Payment(
//     paymentType: PaymentType.cash,
//     amount: 17.95,
//   ),
//   Payment(
//     paymentType: PaymentType.cash,
//     amount: 1.75,
//   ),
//   Payment(
//     paymentType: PaymentType.pix,
//     amount: 2.25,
//   ),
// ];

// final mockSaleItems = [
//   SaleItem(
//     uuid: _uuid.v4(),
//     product: mockProducts[0],
//     quantity: 1,
//     unitPrice: mockProducts[0].price,
//   ),
//   SaleItem(
//     uuid: _uuid.v4(),
//     product: mockProducts[1],
//     quantity: 4,
//     unitPrice: mockProducts[1].price,
//   ),
//   SaleItem(
//     uuid: _uuid.v4(),
//     product: mockProducts[2],
//     quantity: 2,
//     unitPrice: mockProducts[2].price,
//   ),
// ];

// final mockSales = [
//   Sale(
//     uuid: _uuid.v4(),
//     items: mockSaleItems.sublist(0, 2),
//     total: mockSaleItems
//         .sublist(0, 2)
//         .fold(0, (total, i) => total + i.unitPrice * i.quantity),
//     payments: mockPayments.sublist(0, 1),
//     client: mockClients[0],
//     createdAt: DateTime(2023, 8, 31, 14, 38, 23),
//   ),
//   Sale(
//     uuid: _uuid.v4(),
//     items: mockSaleItems.sublist(1, 2),
//     total: mockSaleItems
//         .sublist(1, 2)
//         .fold(0, (total, i) => total + i.unitPrice * i.quantity),
//     createdAt: DateTime(2023, 9, 1, 11, 20, 05),
//     payments: mockPayments.sublist(1, 2),
//   ),
// ];

// class SalesRepositoryMock implements SalesRepository {
//   final _sales = mockSales;
//   final _payments = mockPayments;

//   Future<T> _delayed<T>(T Function() callback) {
//     return Future.delayed(_delay, callback);
//   }

//   @override
//   Future<Sale> createSale({
//     required Map<Product, int> items,
//     Client? client,
//   }) async {
//     final saleItems = items.entries.fold<List<SaleItem>>(
//       [],
//       (saleItems, entry) {
//         final product = entry.key;
//         final quantity = entry.value;
//         final saleItem = SaleItem(
//           uuid: _uuid.v4(),
//           product: product,
//           quantity: quantity,
//           unitPrice: product.price,
//         );
//         saleItems.add(saleItem);
//         return saleItems;
//       },
//     );
//     final sale = Sale(
//       uuid: _uuid.v4(),
//       items: saleItems,
//       total: saleItems.fold(0, (total, i) => total + i.unitPrice * i.quantity),
//       client: client,
//       createdAt: DateTime.now(),
//     );
//     await _delayed(() => _sales.add(sale));
//     return sale;
//   }

//   @override
//   Future<Sale> loadSaleByUuid(String uuid) {
//     return _delayed(() => _sales.firstWhere((s) => s.uuid == uuid));
//   }

//   @override
//   Future<List<Sale>> list() => _delayed(() => _sales);

//   @override
//   Future<void> removeSale(String uuid) =>
//       _delayed(() => _sales.removeWhere((s) => s.uuid == uuid));

//   @override
//   Future<Sale> addPayment({
//     required Sale sale,
//     required PaymentType type,
//     required double amount,
//   }) async {
//     final payment = Payment(
//       paymentType: type,
//       amount: amount,
//     );
//     _payments.add(payment);

//     final saleIndex = _sales.indexWhere((s) => s.uuid == sale.uuid);

//     final newSale = Sale(
//       uuid: sale.uuid,
//       items: sale.items,
//       total: sale.total,
//       payments: [...sale.payments, payment],
//       createdAt: sale.createdAt,
//       client: sale.client,
//     );
//     _sales[saleIndex] = newSale;

//     return await _delayed(() => newSale);
//   }

//   @override
//   Future<Sale> removePayment({
//     required Sale sale,
//     required Payment payment,
//   }) async {
//     _payments.remove(payment);

//     final saleIndex = _sales.indexWhere((s) => s.uuid == sale.uuid);

//     final payments = sale.payments.where((p) => p != payment).toList();

//     final newSale = Sale(
//       uuid: sale.uuid,
//       items: sale.items,
//       total: sale.total,
//       payments: payments,
//       createdAt: sale.createdAt,
//       client: sale.client,
//     );
//     _sales[saleIndex] = newSale;

//     return await _delayed(() => newSale);
//   }
// }
