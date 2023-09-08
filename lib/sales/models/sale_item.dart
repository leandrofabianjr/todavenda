import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/models/models.dart';

class SaleItem extends Equatable {
  const SaleItem({
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

  String get formattedUnitPrice => CurrencyFormatter().formatPtBr(unitPrice);

  Map<String, dynamic> toJson() {
    return {
      'productUuid': product.uuid,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  static SaleItem fromJson(Map<String, dynamic> json, List<Product> products) {
    return SaleItem(
      product: products.firstWhere((c) => c.uuid == json['productUuid']),
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
    );
  }
}
