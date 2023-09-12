import 'package:equatable/equatable.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/models/payment.dart';

import 'sale_item.dart';

class Sale extends Equatable {
  const Sale({
    this.uuid,
    required this.items,
    required this.total,
    this.payments = const [],
    this.client,
    this.createdAt,
    this.amountPaid = 0,
  });

  final String? uuid;
  final List<SaleItem> items;
  final double total;
  final List<Payment> payments;
  final Client? client;
  final DateTime? createdAt;
  final double amountPaid;

  String get formattedCreatedAt => DateTimeFormatter.shortDateTime(createdAt);

  int get quantity => items.fold(0, (total, i) => total + i.quantity);
  double get missingAmountPaid => total - calculateAmountPaid();
  bool get isFullyPaid => missingAmountPaid <= 0;
  bool get isNotFullyPaid => !isFullyPaid;

  @override
  List<Object?> get props => [uuid];

  String get summary {
    final qtt = quantity;
    var text = "$qtt ite${qtt == 1 ? 'm' : 'ns'}";
    if (qtt > 0) {
      text +=
          " (${items.map((e) => "${e.quantity} x ${e.product.description}").join(', ')})";
    }
    return text;
  }

  String get formattedTotal => CurrencyFormatter().formatPtBr(total);
  String get formattedAmountPaid =>
      CurrencyFormatter().formatPtBr(calculateAmountPaid());
  String get formattedMissingAmountPaid =>
      CurrencyFormatter().formatPtBr(missingAmountPaid);

  double calculateAmountPaid() =>
      payments.fold(0.0, (total, p) => total + p.value);

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'paymentsUuids': payments.map((e) => e.uuid).toList(),
      'clientUuid': client?.uuid,
      'createdAt': createdAt.toString(),
      'amountPaid': calculateAmountPaid(),
    };
  }

  static Sale fromJson(
    Map<String, dynamic> json,
    List<Product> products,
    List<Client> clients,
    List<Payment> payments,
  ) {
    return Sale(
      uuid: json['uuid'],
      items: (json['items'] as List)
          .map((e) => SaleItem.fromJson(e, products))
          .toList(),
      payments: ((json['paymentsUuids'] ?? []) as List)
          .map((e) => payments.firstWhere((c) => c.uuid == e))
          .toList(),
      total: json['total'],
      client: json['clientUuid'] == null
          ? null
          : clients.firstWhere((c) => c.uuid == json['clientUuid']),
      createdAt: DateTime.tryParse(json['createdAt']),
      amountPaid: json['amountPaid'] ?? 0,
    );
  }

  Sale copyWith({
    List<Payment>? payments,
    double? amountPaid,
  }) {
    return Sale(
      uuid: uuid,
      items: items,
      total: total,
      payments: payments ?? this.payments,
      client: client,
      createdAt: createdAt,
      amountPaid: amountPaid ?? this.amountPaid,
    );
  }
}
