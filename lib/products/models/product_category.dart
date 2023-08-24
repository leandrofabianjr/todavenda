import 'package:equatable/equatable.dart';
import 'package:todavenda/products/models/product.dart';

class ProductCategory extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final List<Product>? products;

  const ProductCategory({
    this.id,
    required this.name,
    this.description,
    this.products,
  });

  @override
  List<Object?> get props => [id];
}
