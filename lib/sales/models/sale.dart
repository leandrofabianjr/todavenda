import 'package:equatable/equatable.dart';

import 'sale_item.dart';

class Sale extends Equatable {
  const Sale({
    this.uuid,
    required this.items,
    required this.total,
  });

  final String? uuid;
  final List<SaleItem> items;
  final double total;

  @override
  List<Object?> get props => [uuid];
}
