import 'package:equatable/equatable.dart';

import 'cart_item.dart';

class Cart extends Equatable {
  const Cart({
    this.uuid,
    required this.items,
    required this.total,
  });

  final String? uuid;
  final List<CartItem> items;
  final double total;

  @override
  List<Object?> get props => [uuid];
}
