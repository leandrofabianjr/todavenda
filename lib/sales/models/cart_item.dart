import 'package:equatable/equatable.dart';
import 'package:todavenda/products/models/models.dart';

class CartItem extends Equatable {
  const CartItem({
    this.uuid,
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });
  final String? uuid;
  final Product product;
  final int quantity;
  final double unitPrice;

  @override
  List<Object?> get props => [uuid];
}