import 'package:equatable/equatable.dart';
import 'package:todavenda/products/models/product_category.dart';

class Product extends Equatable {
  final String? id;
  final String description;
  final bool active;
  final List<ProductCategory>? categories;
  final double price;

  const Product({
    this.id,
    required this.description,
    this.active = true,
    this.categories,
    required this.price,
  });

  @override
  List<Object?> get props => [id];
}
