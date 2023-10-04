part of 'product_form_bloc.dart';

sealed class ProductFormEvent extends Equatable {
  const ProductFormEvent();
}

class ProductFormStarted extends ProductFormEvent {
  const ProductFormStarted({this.uuid});

  final String? uuid;

  @override
  List<Object?> get props => [uuid];
}

final class ProductFormSubmitted extends ProductFormEvent {
  const ProductFormSubmitted({
    this.uuid,
    required this.description,
    required this.price,
    required this.categories,
    required this.currentStock,
    required this.hasStockControl,
    required this.createdAt,
  });

  final String? uuid;
  final String description;
  final double price;
  final List<ProductCategory> categories;
  final int currentStock;
  final bool hasStockControl;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        uuid,
        description,
        price,
        categories,
        currentStock,
        hasStockControl,
        createdAt,
      ];
}
