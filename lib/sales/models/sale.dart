import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/commons/commons.dart';
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
  });

  final String? uuid;
  final List<SaleItem> items;
  final double total;
  final List<Payment> payments;
  final Client? client;
  final DateTime? createdAt;

  String get formattedCreatedAt => DateTimeFormatter.shortDateTime(createdAt);

  int get quantity => items.fold(0, (total, i) => total + i.quantity);
  double get amountPaid => payments.fold(0.0, (total, p) => total + p.value);
  double get missingAmountPaid => total - amountPaid;
  bool get isFullyPaid => missingAmountPaid <= 0;

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
  String get formattedAmountPaid => CurrencyFormatter().formatPtBr(amountPaid);

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'payments': payments.map((e) => e.toJson()).toList(),
      'client': client?.toJson(),
      'createdAt': createdAt.toString(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
