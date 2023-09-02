import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:todavenda/sales/models/payment.dart';

import 'sale_item.dart';

class Sale extends Equatable {
  const Sale({
    this.uuid,
    required this.items,
    required this.total,
    this.payments = const [],
  });

  final String? uuid;
  final List<SaleItem> items;
  final double total;
  final List<Payment> payments;

  double get amountPaid => payments.fold(0.0, (total, p) => total + p.value);
  double get missingAmountPaid => total - amountPaid;
  bool get isFullyPaid => missingAmountPaid <= 0;

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'payments': payments.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
