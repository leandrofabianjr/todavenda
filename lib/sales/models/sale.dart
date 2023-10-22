import 'package:equatable/equatable.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/sales/models/payment.dart';
import 'package:todavenda/session/models/models.dart';

import 'sale_item.dart';

class Sale extends Equatable {
  const Sale({
    this.uuid,
    required this.items,
    required this.total,
    this.payments = const [],
    this.client,
    required this.createdAt,
    this.amountPaid = 0,
    required this.session,
  });

  final String? uuid;
  final List<SaleItem> items;
  final double total;
  final List<Payment> payments;
  final Client? client;
  final DateTime createdAt;
  final double amountPaid;
  final Session session;

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
      payments.fold(0.0, (total, p) => total + p.amount);

  Map<String, dynamic> toFirestore() {
    return {
      'uuid': uuid,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'paymentsUuids': payments.map((e) => e.uuid).toList(),
      'clientUuid': client?.uuid,
      'createdAt': createdAt,
      'amountPaid': calculateAmountPaid(),
      'sessionUuid': session.uuid,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'payments':
          payments.map((e) => e.toJson(DateTimeConverterType.string)).toList(),
      'client': client?.toJson(),
      'createdAt': createdAt.toString(),
      'amountPaid': calculateAmountPaid(),
      'session': session.toJson(DateTimeConverterType.string),
    };
  }

  static Sale fromJson(
      Map<String, dynamic> json, DateTimeConverterType dateTimeType) {
    return Sale(
      uuid: json['uuid'],
      items: (json['items'] as List)
          .map((e) => SaleItem.fromJson(e, dateTimeType))
          .toList(),
      payments: ((json['payments'] ?? []) as List)
          .map((e) => Payment.fromJson(e, dateTimeType))
          .toList(),
      total: json['total'],
      client: json['client'] == null ? null : Client.fromJson(json['client']),
      createdAt: DateTimeConverter.parse(dateTimeType, json['createdAt']),
      amountPaid: json['amountPaid'] ?? 0,
      session: Session.fromJson(json['session'], dateTimeType),
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
      session: session,
    );
  }

  static Map<PaymentType, double> totalsByPaymentType(List<Sale> sales) {
    final Map<PaymentType, double> totalsByType = {};

    for (final sale in sales) {
      for (final payment in sale.payments) {
        if (!totalsByType.containsKey(payment.paymentType)) {
          totalsByType[payment.paymentType] = 0;
        }
        totalsByType[payment.paymentType] =
            totalsByType[payment.paymentType]! + payment.amount;
      }
    }
    return totalsByType;
  }
}
