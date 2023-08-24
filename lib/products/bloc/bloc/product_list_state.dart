part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

final class ProductListLoading extends ProductListState {}

final class ProductListLoaded extends ProductListState {
  const ProductListLoaded(this.products);

  final List<Product> products;

  @override
  List<Object> get props => [products];
}

final class ProductListException extends ProductListState {}
