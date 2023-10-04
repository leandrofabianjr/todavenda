part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();
}

final class ProductListLoading extends ProductListState {
  @override
  List<Object?> get props => [];
}

final class ProductListLoaded extends ProductListState {
  const ProductListLoaded({required this.products, required this.filter});

  final List<Product> products;
  final ProductListFilter filter;

  @override
  List<Object> get props => [products, filter];
}

final class ProductListException extends ProductListState {
  const ProductListException(this.ex);

  final Object? ex;

  @override
  List<Object?> get props => [ex];
}
