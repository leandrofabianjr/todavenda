import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';

import 'product_category.dart';

class Product extends Equatable {
  final String? uuid;
  final String description;
  final double price;
  final List<ProductCategory>? categories;
  final bool active;

  const Product({
    this.uuid,
    required this.description,
    required this.price,
    this.categories,
    this.active = true,
  });

  get formattedPrice => CurrencyFormatter().formatPtBr(price);

  @override
  List<Object?> get props => [uuid];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'description': description,
      'price': price,
      'categories': (categories ?? []).map((e) => e.toJson()).toList(),
      'active': active,
    };
  }
}
