part of 'product_stock_list_bloc.dart';

sealed class ProductStockListState extends Equatable {
  const ProductStockListState();
}

final class ProductStockListLoading extends ProductStockListState {
  @override
  List<Object?> get props => [];
}

final class ProductStockListLoaded extends ProductStockListState {
  const ProductStockListLoaded(this.productStocks);

  final List<ProductStock> productStocks;

  @override
  List<Object> get props => [productStocks];
}

final class ProductStockListException extends ProductStockListState {
  const ProductStockListException(this.ex);

  final Object? ex;

  @override
  List<Object?> get props => [ex];
}
