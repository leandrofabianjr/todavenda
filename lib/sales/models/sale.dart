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

  @override
  List<Object?> get props => [uuid];
}
