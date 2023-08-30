import 'package:equatable/equatable.dart';

import 'product.dart';

class ProductCategory extends Equatable {
  final String? uuid;
  final String name;
  final String? description;
  final List<Product>? products;

  const ProductCategory({
    this.uuid,
    required this.name,
    this.description,
    this.products,
  });

  @override
  List<Object?> get props => [uuid];
}
