part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();
}

final class ProductLoading extends ProductState {
  @override
  List<Object> get props => [];
}

final class ProductLoaded extends ProductState {
  const ProductLoaded({required this.product});

  final Product product;

  @override
  List<Object> get props => [product];
}

final class ProductException extends ProductState {
  const ProductException(this.ex);

  final Object? ex;
  @override
  List<Object?> get props => [ex];
}
