import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';

import 'product_category.dart';

class Product extends Equatable {
  final String? uuid;
  final String description;
  final bool active;
  final List<ProductCategory>? categories;
  final double price;

  const Product({
    this.uuid,
    required this.description,
    this.active = true,
    this.categories,
    required this.price,
  });

  get formattedPrice => CurrencyFormatter().formatPtBr(price);

  @override
  List<Object?> get props => [uuid];
}
