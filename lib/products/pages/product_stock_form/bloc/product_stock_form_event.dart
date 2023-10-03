part of 'product_stock_form_bloc.dart';

sealed class ProductStockFormEvent extends Equatable {
  const ProductStockFormEvent();
}

class ProductStockFormStarted extends ProductStockFormEvent {
  const ProductStockFormStarted();

  @override
  List<Object?> get props => [];
}

final class ProductStockFormSubmitted extends ProductStockFormEvent {
  const ProductStockFormSubmitted({
    this.quantity,
    this.createdAt,
    this.observation,
  });

  final int? quantity;
  final DateTime? createdAt;
  final String? observation;

  @override
  List<Object?> get props => [quantity, createdAt, observation];
}
