part of 'product_stock_form_bloc.dart';

enum ProductStockFormStatus {
  loading,
  editing,
  success,
  exception,
}

class ProductStockFormState extends Equatable {
  const ProductStockFormState({
    this.status = ProductStockFormStatus.loading,
    this.quantity,
    this.createdAt,
    this.observation,
    this.quantityError,
    this.repository,
    this.exception,
    this.product,
  });

  final ProductStockFormStatus status;
  final int? quantity;
  final DateTime? createdAt;
  final String? observation;
  final String? quantityError;
  final ProductStockRepository? repository;
  final Object? exception;
  final Product? product;

  @override
  List<Object?> get props => [
        status,
        quantity,
        createdAt,
        observation,
        quantityError,
        repository,
        exception,
        product,
      ];

  ProductStockFormState copyWith({
    ProductStockFormStatus? status,
    int? quantity,
    DateTime? createdAt,
    String? observation,
    String? quantityError,
    ProductStockRepository? repository,
    Object? exception,
    Product? product,
  }) {
    return ProductStockFormState(
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      observation: observation ?? this.observation,
      quantityError: quantityError ?? this.quantityError,
      repository: repository ?? this.repository,
      exception: exception ?? this.exception,
      product: product ?? this.product,
    );
  }
}
